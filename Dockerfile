# Start from the official Go image
FROM golang:1.23.1 AS builder

# Set the working directory inside the container
WORKDIR /app

# Copy all files to the container
COPY . .

# Download dependencies
RUN go mod tidy && go mod download

# Build the Go application
RUN GOOS=linux GOARCH=amd64 go build -o lightnode .

# Start a new minimal image
FROM alpine:latest

# Copy the executable from the builder stage
COPY --from=builder /app/lightnode /usr/local/bin/lightnode

# Expose the port your app runs on
EXPOSE 8080

# Command to run the application
CMD ["lightnode"]
