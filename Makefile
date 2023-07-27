CONTAINER_REPOSITORY=aerosystems
GIT_REPOSITORY=github.com/aerosystems

AUTH_BINARY=auth-service.bin
AUTH_VERSION=1.0.0
PROJECT_BINARY=project-service.bin
PROJECT_VERSION=1.0.0
CHECKMAIL_BINARY=checkmail-service.bin
CHECKMAIL_VERSION=1.0.0
MAIL_BINARY=mail-service.bin
MAIL_VERSION=1.0.0
LOOKUP_BINARY=lookup-service.bin
LOOKUP_VERSION=1.0.0
LISTENER_BINARY=listener-service.bin
LISTENER_VERSION=1.0.0
BROKER_BINARY=broker-service.bin
BROKER_VERSION=1.0.0

## up: starts all containers in the background without forcing build
up:
	@echo "Starting docker images..."
	docker-compose -f ./docker-compose.dev.yml --env-file ./.env.dev up -d
	@echo "Docker images started!"

## down: stop docker compose
down:
	@echo "Stopping docker images..."
	docker-compose -f ./docker-compose.dev.yml --env-file ./.env.dev down
	@echo "Docker stopped!"

## build-up: stops docker-compose (if running), builds all projects and starts docker compose
build-up: build-auth build-project build-checkmail build-mail build-lookup build-listener build-broker
	@echo "Stopping docker images (if running...)"
	docker-compose -f ./docker-compose.dev.yml --env-file ./.env.dev down
	@echo "Building (when required) and starting docker images..."
	docker-compose -f ./docker-compose.dev.yml --env-file ./.env.dev up --build -d
	@echo "Docker images built and started!"

# build-dockerfiles: builds all dockerfile images
build-dockerfiles: build-auth build-project build-checkmail build-mail build-lookup build-listener build-broker
	@echo "Building dockerfiles..."
	docker build -f ../auth-service/Dockerfile -t ${CONTAINER_REPOSITORY}/auth-service:${AUTH_VERSION} ../
	docker build -f ../project-service/Dockerfile -t ${CONTAINER_REPOSITORY}/project-service:${PROJECT_VERSION} ../
	docker build -f ../checkmail-service/Dockerfile -t ${CONTAINER_REPOSITORY}/checkmail-service:${CHECKMAIL_VERSION} ../
	docker build -f ../mail-service/Dockerfile -t ${CONTAINER_REPOSITORY}/mail-service:${MAIL_VERSION} ../
	docker build -f ../lookup-service/Dockerfile -t ${CONTAINER_REPOSITORY}/lookup-service:${LOOKUP_VERSION} ../
	docker build -f ../listener-service/Dockerfile -t ${CONTAINER_REPOSITORY}/listener-service:${LISTENER_VERSION} ../
	docker build -f ../broker-service/Dockerfile -t ${CONTAINER_REPOSITORY}/broker-service:${BROKER_VERSION} ../
	@echo "Dockerfiles built!"

## build-auth: builds the authentication binary as a linux executable
build-auth:
	@echo "Building authentication binary.."
	cd ../auth-service && env GOOS=linux GOARCH=amd64 CGO_ENABLED=0 go build -o ${AUTH_BINARY} ./cmd/api/*
	@echo "Authentication binary built!"

## build-project: builds the project-service binary as a linux executable
build-project:
	@echo "Building project-service binary.."
	cd ../project-service && env GOOS=linux GOARCH=amd64 CGO_ENABLED=0 go build -o ${PROJECT_BINARY} ./cmd/api/*
	@echo "project-service binary built!"

## build-checkmail: builds the checkmail-service binary as a linux executable
build-checkmail:
	@echo "Building checkmail-service binary.."
	cd ../checkmail-service && env GOOS=linux GOARCH=amd64 CGO_ENABLED=0 go build -o ${CHECKMAIL_BINARY} ./cmd/api/*
	@echo "checkmail-service binary built!"

## build-mail: builds the mail-service binary as a linux executable
build-mail:
	@echo "Building mail-service binary.."
	cd ../mail-service && env GOOS=linux GOARCH=amd64 CGO_ENABLED=0 go build -o ${MAIL_BINARY} ./cmd/app/*
	@echo "mail-service binary built!"

## build-lookup: builds the lookup-service binary as a linux executable
build-lookup:
	@echo "Building lookup-service binary.."
	cd ../lookup-service && env GOOS=linux GOARCH=amd64 CGO_ENABLED=0 go build -o ${LOOKUP_BINARY} ./cmd/app/*
	@echo "lookup-service binary built!"

## build-listener: builds the listener binary as a linux executable
build-listener:
	@echo "Building listener binary..."
	cd ../listener-service && env GOOS=linux GOARCH=amd64 CGO_ENABLED=0 go build -o ${LISTENER_BINARY} .
	@echo "Listener binary built!"

## build-broker: builds the broker binary as a linux executable
build-broker:
	@echo "Building broker binary..."
	cd ../broker-service && env GOOS=linux GOARCH=amd64 CGO_ENABLED=0 go build -o ${BROKER_BINARY} ./cmd/api/*
	@echo "Broker binary built!"

## auth: stops auth-service, removes docker image, builds service, and starts it
auth: build-auth
	@echo "Building auth-service docker image..."
	docker-compose -f ./docker-compose.dev.yml --env-file ./.env.dev stop auth-service
	docker-compose -f ./docker-compose.dev.yml --env-file ./.env.dev rm -f auth-service
	docker-compose -f ./docker-compose.dev.yml --env-file ./.env.dev up --build -d auth-service
	docker-compose -f ./docker-compose.dev.yml --env-file ./.env.dev start auth-service
	@echo "auth-service built and started!"

## project: stops project-service, removes docker image, builds service, and starts it
project: build-project
	@echo "Building project-service docker image..."
	docker-compose -f ./docker-compose.dev.yml --env-file ./.env.dev stop project-service
	docker-compose -f ./docker-compose.dev.yml --env-file ./.env.dev rm -f project-service
	docker-compose -f ./docker-compose.dev.yml --env-file ./.env.dev up --build -d project-service
	docker-compose -f ./docker-compose.dev.yml --env-file ./.env.dev start project-service
	@echo "project-service built and started!"
	
## checkmail: stops checkmail-service, removes docker image, builds service, and starts it
checkmail: build-checkmail
	@echo "Building checkmail-service docker image..."
	docker-compose -f ./docker-compose.dev.yml --env-file ./.env.dev stop checkmail-service
	docker-compose -f ./docker-compose.dev.yml --env-file ./.env.dev rm -f checkmail-service
	docker-compose -f ./docker-compose.dev.yml --env-file ./.env.dev up --build -d checkmail-service
	docker-compose -f ./docker-compose.dev.yml --env-file ./.env.dev start checkmail-service
	@echo "checkmail-service built and started!"

## mail: stops mail-service, removes docker image, builds service, and starts it
mail: build-mail
	@echo "Building mail-service docker image..."
	docker-compose -f ./docker-compose.dev.yml --env-file ./.env.dev stop mail-service
	docker-compose -f ./docker-compose.dev.yml --env-file ./.env.dev rm -f mail-service
	docker-compose -f ./docker-compose.dev.yml --env-file ./.env.dev up --build -d mail-service
	docker-compose -f ./docker-compose.dev.yml --env-file ./.env.dev start mail-service
	@echo "mail-service built and started!"

## lookup: stops lookup-service, removes docker image, builds service, and starts it
lookup: build-lookup
	@echo "Building lookup-service docker image..."
	docker-compose -f ./docker-compose.dev.yml --env-file ./.env.dev stop lookup-service
	docker-compose -f ./docker-compose.dev.yml --env-file ./.env.dev rm -f lookup-service
	docker-compose -f ./docker-compose.dev.yml --env-file ./.env.dev up --build -d lookup-service
	docker-compose -f ./docker-compose.dev.yml --env-file ./.env.dev start lookup-service
	@echo "lookup-service built and started!"

## listener: stops listener-service, removes docker image, builds service, and starts it
listener: build-listener
	@echo "Building listener-service docker image..."
	docker-compose -f ./docker-compose.dev.yml --env-file ./.env.dev stop listener-service
	docker-compose -f ./docker-compose.dev.yml --env-file ./.env.dev rm -f listener-service
	docker-compose -f ./docker-compose.dev.yml --env-file ./.env.dev up --build -d listener-service
	docker-compose -f ./docker-compose.dev.yml --env-file ./.env.dev start listener-service
	@echo "listener-service rebuilt and started!"

## broker: stops broker-service, removes docker image, builds service, and starts it
broker: build-broker
	@echo "Building broker-service docker image..."
	docker-compose -f ./docker-compose.dev.yml --env-file ./.env.dev stop broker-service
	docker-compose -f ./docker-compose.dev.yml --env-file ./.env.dev rm -f broker-service
	docker-compose -f ./docker-compose.dev.yml --env-file ./.env.dev up --build -d broker-service
	docker-compose -f ./docker-compose.dev.yml --env-file ./.env.dev start broker-service
	@echo "broker-service rebuilt and started!"

## clean: runs go clean and deletes binaries
clean:
	@echo "Cleaning..."
	@cd ../auth-service && rm -f ${AUTH_BINARY}
	@cd ../auth-service && go clean
	@cd ../project-service && rm -f ${PROJECT_BINARY}
	@cd ../project-service && go clean
	@cd ../checkmail-service && rm -f ${CHECKMAIL_BINARY}
	@cd ../checkmail-service && go clean
	@cd ../mail-service && rm -f ${MAIL_BINARY}
	@cd ../mail-service && go clean
	@cd ../lookup-service && rm -f ${LOOKUP_BINARY}
	@cd ../lookup-service && go clean
	@cd ../listener-service && rm -f ${LISTENER_BINARY}
	@cd ../listener-service && go clean
	@cd ../broker-service && rm -f ${BROKER_BINARY}
	@cd ../broker-service && go clean
	@echo "Cleaned!"

## doc: generating Swagger Docs
doc:
	@echo "Stopping generating Swagger Docs..."
	cd ../auth-service; swag init -g cmd/api/* --output docs
	cd ../project-service; swag init -g cmd/api/* --output docs
	cd ../checkmail-service; swag init -g cmd/api/* --output docs

	@echo "Swagger Docs prepared, look at /docs"

## help: displays help
help: Makefile
	@echo " Choose a command:"
	@sed -n 's/^##//p' $< | column -t -s ':' |  sed -e 's/^/ /'