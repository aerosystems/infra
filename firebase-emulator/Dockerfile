FROM node:22-bullseye-slim

WORKDIR /app
COPY . /app

# Install dependencies and build the project
RUN apt-get update -y && \
    apt-get install -y openjdk-17-jdk bash && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    npm install -g firebase-tools


CMD ["firebase", "emulators:start", "--import", "/var/lib/firebase-emulator/data", "--export-on-exit", "/var/lib/firebase-emulator/data"]

