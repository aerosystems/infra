CONTAINER_REPOSITORY=aerosystems
GIT_REPOSITORY=github.com/aerosystems

AUTH_BINARY=auth-service.bin
AUTH_VERSION=1.0.7
PROJECT_BINARY=project-service.bin
PROJECT_VERSION=1.0.6
CHECKMAIL_BINARY=checkmail-service.bin
CHECKMAIL_VERSION=1.0.7
MAIL_BINARY=mail-service.bin
MAIL_VERSION=1.0.0
LOOKUP_BINARY=lookup-service.bin
LOOKUP_VERSION=1.0.0
RECAPTCHA_BINARY=recaptcha-service.bin
RECAPTCHA_VERSION=1.0.0
ADAPTER_BINARY=adapter-service.bin
ADAPTER_VERSION=1.0.0
STAT_BINARY=stat-service.bin
STAT_VERSION=1.0.0
SUBS_BINARY=subs-service.bin
SUBS_VERSION=1.0.0
CUSTOMER_BINARY=customer-service.bin
CUSTOMER_VERSION=1.0.0

## up: starts all containers in the background without forcing build
up:
	@echo "Starting docker images..."
	docker-compose -f ./docker-compose.yml --env-file ./.env up -d
	@echo "Docker images started!"

## down: stop docker compose
down:
	@echo "Stopping docker images..."
	docker-compose -f ./docker-compose.yml --env-file ./.env down
	@echo "Docker stopped!"

## restart: restarts all containers
restart:
	@echo "Restarting docker images..."
	docker-compose -f ./docker-compose.yml --env-file ./.env down
	docker-compose -f ./docker-compose.yml --env-file ./.env up -d
	@echo "Docker restarted!"

## rebuild: stops docker-compose (if running), rebuilds all projects and starts docker compose
rebuild:
	@echo "Rebuilding docker images..."
	docker-compose -f ./docker-compose.yml --env-file ./.env down
	docker-compose -f ./docker-compose.yml --env-file ./.env up --build -d
	@echo "Docker images rebuilt!"

## build-up: stops docker-compose (if running), builds all projects and starts docker compose
build-up: auth-build project-build checkmail-build mail-build lookup-build recaptcha-build adapter-build stat-build subs-build customer-build
	@echo "Stopping docker images (if running...)"
	docker-compose -f ./docker-compose.yml --env-file ./.env down
	@echo "Building (when required) and starting docker images..."
	docker-compose -f ./docker-compose.yml --env-file ./.env up --build -d
	@echo "Docker images built and started!"

# build-dockerfiles: builds all dockerfile images
build-dockerfiles: auth-build project-build checkmail-build mail-build lookup-build recaptcha-build adapter-build stat-build subs-build customer-build
	@echo "Building dockerfiles..."
	docker build -f ../auth-service/Dockerfile -t ${CONTAINER_REPOSITORY}/auth-service:${AUTH_VERSION} ../
	docker build -f ../project-service/Dockerfile -t ${CONTAINER_REPOSITORY}/project-service:${PROJECT_VERSION} ../
	docker build -f ../checkmail-service/Dockerfile -t ${CONTAINER_REPOSITORY}/checkmail-service:${CHECKMAIL_VERSION} ../
	docker build -f ../mail-service/Dockerfile -t ${CONTAINER_REPOSITORY}/mail-service:${MAIL_VERSION} ../
	docker build -f ../lookup-service/Dockerfile -t ${CONTAINER_REPOSITORY}/lookup-service:${LOOKUP_VERSION} ../
	docker build -f ../recaptcha-service/Dockerfile -t ${CONTAINER_REPOSITORY}/recaptcha-service:${RECAPTCHA_VERSION} ../
	docker build -f ../adapter-service/Dockerfile -t ${CONTAINER_REPOSITORY}/adapter-service:${ADAPTER_VERSION} ../
	docker build -f ../stat-service/Dockerfile -t ${CONTAINER_REPOSITORY}/stat-service:${STAT_VERSION} ../
	docker build -f ../subs-service/Dockerfile -t ${CONTAINER_REPOSITORY}/subs-service:${SUBS_VERSION} ../
	docker build -f ../customer-service/Dockerfile -t ${CONTAINER_REPOSITORY}/customer-service:${CUSTOMER_VERSION} ../
	@echo "Dockerfiles built!"

## auth-build: builds the authentication binary as a linux executable
auth-build:
	@echo "Building authentication binary.."
	cd ../auth-service && env GOOS=linux GOARCH=amd64 CGO_ENABLED=0 go build -o ${AUTH_BINARY} ./cmd/app
	@echo "Authentication binary built!"

## project-build: builds the project-service binary as a linux executable
project-build:
	@echo "Building project-service binary.."
	cd ../project-service && env GOOS=linux GOARCH=amd64 CGO_ENABLED=0 go build -o ${PROJECT_BINARY} ./cmd/app
	@echo "project-service binary built!"

## checkmail-build: builds the checkmail-service binary as a linux executable
checkmail-build:
	@echo "Building checkmail-service binary.."
	cd ../checkmail-service && env GOOS=linux GOARCH=amd64 CGO_ENABLED=0 go build -o ${CHECKMAIL_BINARY} ./cmd/app
	@echo "checkmail-service binary built!"

## mail-build: builds the mail-service binary as a linux executable
mail-build:
	@echo "Building mail-service binary.."
	cd ../mail-service && env GOOS=linux GOARCH=amd64 CGO_ENABLED=0 go build -o ${MAIL_BINARY} ./cmd/app/*
	@echo "mail-service binary built!"

## lookup-build: builds the lookup-service binary as a linux executable
lookup-build:
	@echo "Building lookup-service binary.."
	cd ../lookup-service && env GOOS=linux GOARCH=amd64 CGO_ENABLED=0 go build -o ${LOOKUP_BINARY} ./cmd/app
	@echo "lookup-service binary built!"

## recaptcha-build: builds the recaptcha-service binary as a linux executable
recaptcha-build:
	@echo "Building recaptcha-service binary.."
	cd ../recaptcha-service && env GOOS=linux GOARCH=amd64 CGO_ENABLED=0 go build -o ${RECAPTCHA_BINARY} ./cmd/api/*
	@echo "recaptcha-service binary built!"

## adapter-build: builds the adapter-service binary as a linux executable
adapter-build:
	@echo "Building adapter-service binary.."
	cd ../adapter-service && env GOOS=linux GOARCH=amd64 CGO_ENABLED=0 go build -o ${ADAPTER_BINARY} ./cmd/app
	@echo "adapter-service binary built!"

## stat-build: builds the stat-service binary as a linux executable
stat-build:
	@echo "Building stat-service binary.."
	cd ../stat-service && env GOOS=linux GOARCH=amd64 CGO_ENABLED=0 go build -o ${STAT_BINARY} ./cmd/api/*
	@echo "stat-service binary built!"

## subs-build: builds the subs-service binary as a linux executable
subs-build:
	@echo "Building subs-service binary.."
	cd ../subs-service && env GOOS=linux GOARCH=amd64 CGO_ENABLED=0 go build -o ${SUBS_BINARY} ./cmd/app
	@echo "subs-service binary built!"

## customer-build: builds the customer-service binary as a linux executable
customer-build:
	@echo "Building customer-service binary.."
	cd ../customer-service && env GOOS=linux GOARCH=amd64 CGO_ENABLED=0 go build -o ${CUSTOMER_BINARY} ./cmd/app
	@echo "customer-service binary built!"

## gw: stops API Gateway, removes docker image, builds service, and starts it
gw:
	@echo "Building api-gateway docker image..."
	docker-compose -f ./docker-compose.yml --env-file ./.env stop api-gateway
	docker-compose -f ./docker-compose.yml --env-file ./.env rm -f api-gateway
	docker-compose -f ./docker-compose.yml --env-file ./.env up --build -d api-gateway
	docker-compose -f ./docker-compose.yml --env-file ./.env start api-gateway
	@echo "api-gateway built and started!"

## auth: stops auth-service, removes docker image, builds service, and starts it
auth: auth-build
	@echo "Building auth-service docker image..."
	docker-compose -f ./docker-compose.yml --env-file ./.env stop auth-service
	docker-compose -f ./docker-compose.yml --env-file ./.env rm -f auth-service
	docker-compose -f ./docker-compose.yml --env-file ./.env up --build -d auth-service
	docker-compose -f ./docker-compose.yml --env-file ./.env start auth-service
	@echo "auth-service built and started!"

## project: stops project-service, removes docker image, builds service, and starts it
project: project-build
	@echo "Building project-service docker image..."
	docker-compose -f ./docker-compose.yml --env-file ./.env stop project-service
	docker-compose -f ./docker-compose.yml --env-file ./.env rm -f project-service
	docker-compose -f ./docker-compose.yml --env-file ./.env up --build -d project-service
	docker-compose -f ./docker-compose.yml --env-file ./.env start project-service
	@echo "project-service built and started!"
	
## checkmail: stops checkmail-service, removes docker image, builds service, and starts it
checkmail: checkmail-build
	@echo "Building checkmail-service docker image..."
	docker-compose -f ./docker-compose.yml --env-file ./.env stop checkmail-service
	docker-compose -f ./docker-compose.yml --env-file ./.env rm -f checkmail-service
	docker-compose -f ./docker-compose.yml --env-file ./.env up --build -d checkmail-service
	docker-compose -f ./docker-compose.yml --env-file ./.env start checkmail-service
	@echo "checkmail-service built and started!"

## mail: stops mail-service, removes docker image, builds service, and starts it
mail: mail-build
	@echo "Building mail-service docker image..."
	docker-compose -f ./docker-compose.yml --env-file ./.env stop mail-service
	docker-compose -f ./docker-compose.yml --env-file ./.env rm -f mail-service
	docker-compose -f ./docker-compose.yml --env-file ./.env up --build -d mail-service
	docker-compose -f ./docker-compose.yml --env-file ./.env start mail-service
	@echo "mail-service built and started!"

## lookup: stops lookup-service, removes docker image, builds service, and starts it
lookup: lookup-build
	@echo "Building lookup-service docker image..."
	docker-compose -f ./docker-compose.yml --env-file ./.env stop lookup-service
	docker-compose -f ./docker-compose.yml --env-file ./.env rm -f lookup-service
	docker-compose -f ./docker-compose.yml --env-file ./.env up --build -d lookup-service
	docker-compose -f ./docker-compose.yml --env-file ./.env start lookup-service
	@echo "lookup-service built and started!"

## recaptcha: stops recaptcha-service, removes docker image, builds service, and starts it
recaptcha: recaptcha-build
	@echo "Building recaptcha-service docker image..."
	docker-compose -f ./docker-compose.yml --env-file ./.env stop recaptcha-service
	docker-compose -f ./docker-compose.yml --env-file ./.env rm -f recaptcha-service
	docker-compose -f ./docker-compose.yml --env-file ./.env up --build -d recaptcha-service
	docker-compose -f ./docker-compose.yml --env-file ./.env start recaptcha-service
	@echo "recaptcha-service built and started!"

## adapter: stops adapter-service, removes docker image, builds service, and starts it
adapter: adapter-build
	@echo "Building adapter-service docker image..."
	docker-compose -f ./docker-compose.yml --env-file ./.env stop adapter-service
	docker-compose -f ./docker-compose.yml --env-file ./.env rm -f adapter-service
	docker-compose -f ./docker-compose.yml --env-file ./.env up --build -d adapter-service
	docker-compose -f ./docker-compose.yml --env-file ./.env start adapter-service
	@echo "adapter-service built and started!"

## stat: stops stat-service, removes docker image, builds service, and starts it
stat: stat-build
	@echo "Building stat-service docker image..."
	docker-compose -f ./docker-compose.yml --env-file ./.env stop stat-service
	docker-compose -f ./docker-compose.yml --env-file ./.env rm -f stat-service
	docker-compose -f ./docker-compose.yml --env-file ./.env up --build -d stat-service
	docker-compose -f ./docker-compose.yml --env-file ./.env start stat-service
	@echo "stat-service built and started!"

## subs: stops subs-service, removes docker image, builds service, and starts it
subs: subs-build
	@echo "Building subs-service docker image..."
	docker-compose -f ./docker-compose.yml --env-file ./.env stop subs-service
	docker-compose -f ./docker-compose.yml --env-file ./.env rm -f subs-service
	docker-compose -f ./docker-compose.yml --env-file ./.env up --build -d subs-service
	docker-compose -f ./docker-compose.yml --env-file ./.env start subs-service
	@echo "subs-service built and started!"

## customer: stops customer-service, removes docker image, builds service, and starts it
customer: customer-build
	@echo "Building customer-service docker image..."
	docker-compose -f ./docker-compose.yml --env-file ./.env stop customer-service
	docker-compose -f ./docker-compose.yml --env-file ./.env rm -f customer-service
	docker-compose -f ./docker-compose.yml --env-file ./.env up --build -d customer-service
	docker-compose -f ./docker-compose.yml --env-file ./.env start customer-service
	@echo "customer-service built and started!"

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
	@cd ../recapthca-service && rm -f ${RECAPTCHA_BINARY}
	@cd ../recapthca-service && go clean
	@cd ../adapter-service && rm -f ${ADAPTER_BINARY}
	@cd ../adapter-service && go clean
	@cd ../stat-service && rm -f ${STAT_BINARY}
	@cd ../stat-service && go clean
	@cd ../subs-service && rm -f ${SUBS_BINARY}
	@cd ../subs-service && go clean
	@cd ../customer-service && rm -f ${CUSTOMER_BINARY}
	@cd ../customer-service && go clean
	@echo "Cleaned!"

## doc: generating Swagger Docs
doc:
	@echo "Stopping generating Swagger Docs..."
	cd ../auth-service; swag init -g ./cmd/app/main.go -o ./docs
	cd ../project-service; swag init -g ./cmd/app/main.go -o ./docs
	cd ../mail-service; swag init -g ./cmd/app/main.go -o ./docs
	cd ../checkmail-service; swag init -g ./cmd/app/main.go -o ./docs
	cd ../lookup-service; swag init -g ./cmd/app/main.go -o ./docs
	cd ../recaptcha-service; swag init -g ./cmd/api/main.go -o ./docs
	cd ../adapter-service; swag init -g ./cmd/app/main.go -o ./docs
	cd ../stat-service; swag init -g ./cmd/api/main.go -o ./docs
	cd ../subs-service; swag init -g ./cmd/app/main.go -o ./docs
	cd ../customer-service; swag init -g ./cmd/app/main.go -o ./docs
	@echo "Swagger Docs prepared, look at /docs"

## help: displays help
help: Makefile
	@echo " Choose a command:"
	@sed -n 's/^##//p' $< | column -t -s ':' |  sed -e 's/^/ /'