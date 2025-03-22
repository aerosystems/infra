// Package p contains a Cloud Function that processes Firebase
// Authentication events.
package user_push

import (
	"context"
	"encoding/json"
	"fmt"
	"log"
	"os"

	"cloud.google.com/go/functions/metadata"
	"cloud.google.com/go/pubsub"
)

// AuthEvent is the payload of a Firebase Auth event.
// Please refer to the docs for additional information
// regarding Firebase Auth events.
type AuthEvent struct {
	Email string `json:"email"`
	UID   string `json:"uid"`
}

// PubSubMessage - структура для отримання повідомлень із Pub/Sub
type PubSubMessage struct {
	Data []byte `json:"data"`
}

// TopicName - назва Pub/Sub Topic
const TopicName = "firebase-authentication"

// HelloAuth handles changes to Firebase Auth user objects.
func HelloAuth(ctx context.Context, e AuthEvent) error {
	meta, err := metadata.FromContext(ctx)
	if err != nil {
		return fmt.Errorf("metadata.FromContext: %v", err)
	}
	log.Printf("Function triggered by change to: %v", meta.Resource)
	log.Printf("%v", e)
	client, err := pubsub.NewClient(ctx, os.Getenv("GOOGLE_CLOUD_PROJECT"))
	if err != nil {
		return fmt.Errorf("failed to create Pub/Sub client: %v", err)
	}
	defer client.Close()

	// Отримання топіка
	topic := client.Topic(TopicName)

	// Серіалізація події в JSON
	messageData, err := json.Marshal(e)
	if err != nil {
		return fmt.Errorf("failed to marshal user event: %v", err)
	}

	// Публікація повідомлення
	result := topic.Publish(ctx, &pubsub.Message{
		Data: messageData,
	})

	// Перевірка результату
	_, err = result.Get(ctx)
	if err != nil {
		return fmt.Errorf("failed to publish message to Pub/Sub: %v", err)
	}

	log.Printf("Message published to Pub/Sub topic %s: %s", TopicName, string(messageData))
	return nil
}
