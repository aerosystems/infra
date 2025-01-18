FROM node:22-bullseye-slim

WORKDIR /app
COPY . /app

# Install dependencies and build the project
RUN apt-get update -y && \
    apt-get install -y openjdk-17-jdk bash && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    npm install -g firebase-tools && \
    npm --prefix /app/functions ci

# Ensure the entrypoint script is in place and executable
RUN echo '#!/bin/sh' > /app/entrypoint.sh && \
    echo 'firebase emulators:start' >> /app/entrypoint.sh && \
    chmod +x /app/entrypoint.sh

ENTRYPOINT ["/app/entrypoint.sh"]
