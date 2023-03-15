CONTAINER_REPOSITORY=aerosystems
GIT_REPOSITORY=github.com/aerosystems

AUTH_BINARY=auth-service.bin
AUTH_VERSION=1.0.0
PROJECT_BINARY=project-service.bin
PROJECT_VERSION=1.0.0
LOG_BINARY=log-service.bin
LOG_VERSION=1.0.0
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
build-up: build-auth build-project build-log build-listener build-broker
	@echo "Stopping docker images (if running...)"
	docker-compose -f ./docker-compose.dev.yml --env-file ./.env.dev down
	@echo "Building (when required) and starting docker images..."
	docker-compose -f ./docker-compose.dev.yml --env-file ./.env.dev up --build -d
	@echo "Docker images built and started!"

# build-dockerfiles: builds all dockerfile images
build-dockerfiles: build-auth build-project build-broker build-listener build-log
	@echo "Building dockerfiles..."
	docker build -f ../auth-service/auth-service.dockerfile -t ${CONTAINER_REPOSITORY}/auth-service:${AUTH_VERSION} ../
	docker build -f ../broker-service/broker-service.dockerfile -t ${CONTAINER_REPOSITORY}/broker-service:${AUTH_VERSION} ../
	docker build -f ../listener-service/listener-service.dockerfile -t ${CONTAINER_REPOSITORY}/listener-service:${AUTH_VERSION} ../
	docker build -f ../log-service/log-service.dockerfile -t ${CONTAINER_REPOSITORY}/log-service:${AUTH_VERSION} ../

## build-auth: builds the authentication binary as a linux executable
build-auth:
	@echo "Building authentication binary.."
	cd ../auth-service && env GOOS=linux GOARCH=amd64 CGO_ENABLED=0 go build -o ${AUTH_BINARY} ./cmd/api
	@echo "Authentication binary built!"

## build-project: builds the project-service binary as a linux executable
build-project:
	@echo "Building project-service binary.."
	cd ../project-service && env GOOS=linux GOARCH=amd64 CGO_ENABLED=0 go build -o ${PROJECT_BINARY} ./cmd/api
	@echo "project-service binary built!"


## build-log: builds the logger binary as a linux executable
build-log:
	@echo "Building log binary..."
	cd ../log-service && env GOOS=linux GOARCH=amd64 CGO_ENABLED=0 go build -o ${LOG_BINARY} ./cmd/web
	@echo "Log binary built!"

## build-listener: builds the listener binary as a linux executable
build-listener:
	@echo "Building listener binary..."
	cd ../listener-service && env GOOS=linux GOARCH=amd64 CGO_ENABLED=0 go build -o ${LISTENER_BINARY} .
	@echo "Listener binary built!"

## build-broker: builds the broker binary as a linux executable
build-broker:
	@echo "Building broker binary..."
	cd ../broker-service && env GOOS=linux GOARCH=amd64 CGO_ENABLED=0 go build -o ${BROKER_BINARY} ./cmd/api
	@echo "Broker binary built!"

## auth: stops auth-service, removes docker image, builds service, and starts it
auth: build-auth
	@echo "Building auth-service docker image..."
	- docker-compose -f ./docker-compose.dev.yml --env-file ./.env.dev stop auth-service
	- docker-compose -f ./docker-compose.dev.yml --env-file ./.env.dev rm -f auth-service
	docker-compose -f ./docker-compose.dev.yml --env-file ./.env.dev up --build -d auth-service
	docker-compose -f ./docker-compose.dev.yml --env-file ./.env.dev start auth-service
	@echo "auth-service built and started!"

## project: stops project-service, removes docker image, builds service, and starts it
project: build-project
	@echo "Building project-service docker image..."
	- docker-compose -f ./docker-compose.dev.yml --env-file ./.env.dev stop project-service
	- docker-compose -f ./docker-compose.dev.yml --env-file ./.env.dev rm -f project-service
	docker-compose -f ./docker-compose.dev.yml --env-file ./.env.dev up --build -d project-service
	docker-compose -f ./docker-compose.dev.yml --env-file ./.env.dev start project-service
	@echo "project-service built and started!"

## log: stops log-service, removes docker image, builds service, and starts it
log: build-log
	@echo "Building log-service docker image..."
	- docker-compose -f ./docker-compose.dev.yml --env-file ./.env.dev stop log-service
	- docker-compose -f ./docker-compose.dev.yml --env-file ./.env.dev rm -f log-service
	docker-compose -f ./docker-compose.dev.yml --env-file ./.env.dev up --build -d log-service
	docker-compose -f ./docker-compose.dev.yml --env-file ./.env.dev start log-service
	@echo "log-service rebuilt and started!"

## listener: stops listener-service, removes docker image, builds service, and starts it
listener: build-listener
	@echo "Building listener-service docker image..."
	- docker-compose -f ./docker-compose.dev.yml --env-file ./.env.dev stop listener-service
	- docker-compose -f ./docker-compose.dev.yml --env-file ./.env.dev rm -f listener-service
	docker-compose -f ./docker-compose.dev.yml --env-file ./.env.dev up --build -d listener-service
	docker-compose -f ./docker-compose.dev.yml --env-file ./.env.dev start listener-service
	@echo "listener-service rebuilt and started!"

## broker: stops broker-service, removes docker image, builds service, and starts it
broker: build-broker
	@echo "Building broker-service docker image..."
	- docker-compose -f ./docker-compose.dev.yml --env-file ./.env.dev stop broker-service
	- docker-compose -f ./docker-compose.dev.yml --env-file ./.env.dev rm -f broker-service
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
	@cd ../log-service && rm -f ${LOG_BINARY}
	@cd ../log-service && go clean
	@cd ../listener-service && rm -f ${LISTENER_BINARY}
	@cd ../listener-service && go clean
	@cd ../broker-service && rm -f ${BROKER_BINARY}
	@cd ../broker-service && go clean
	@echo "Cleaned!"

## import-dump: import SQL dump on running postgres container, required param "db" - database name, "dump" - path for sql dump file
import-dump:
	echo "DROP DATABASE \"$(db)\"" | docker exec -i postgres psql -U postgres
	echo "CREATE DATABASE \"$(db)\"" | docker exec -i postgres psql -U postgres
	cat $(dump) | docker exec -i postgres psql -d $(db) -U postgres

## doc: generating Swagger Docs
doc:
	@echo "Stopping generating Swagger Docs..."
	swag init -g ../auth-service/cmd/api/* --output ../auth-service/docs
	@echo "Swagger Docs prepared, look at /docs"

## help: displays help
help: Makefile
	@echo " Choose a command:"
	@sed -n 's/^##//p' $< | column -t -s ':' |  sed -e 's/^/ /'