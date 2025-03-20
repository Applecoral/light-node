# Use the official Go image as the build stage
FROM golang:1.23.1 AS builder

WORKDIR /app
COPY . .

# Install dependencies
RUN go mod tidy && go mod download

# Build the CLI app for Linux
RUN GOOS=linux GOARCH=amd64 go build -o lightnode .

# Create a minimal runtime container
FROM debian:buster-slim

WORKDIR /app
COPY --from=builder /app/lightnode .

# Run the CLI app
CMD ["./lightnode"]
