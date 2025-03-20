# Step 1: Use Go 1.23.1 image from Docker Hub
FROM golang:1.23.1-alpine AS builder

# Step 2: Set the working directory inside the container
WORKDIR /app

# Step 3: Copy go.mod and go.sum files and download dependencies
COPY go.mod go.sum ./
RUN go mod tidy && go mod download

# Step 4: Copy the entire application code
COPY . .

# Step 5: Build the application with necessary flags
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o lightnode

# Step 6: Use a minimal base image for the final container
FROM alpine:latest

WORKDIR /root/

# Step 7: Copy the built application from the builder stage
COPY --from=builder /app/lightnode .

# Step 8: Set the default command to run the CLI
CMD ["./lightnode"]
