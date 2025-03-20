# Step 1: Build Stage
FROM golang:1.20 AS builder

WORKDIR /app

# Copy the Go module files and download dependencies
COPY go.mod go.sum ./
RUN go mod tidy && go mod download

# Copy the rest of the code and build the app
COPY . .
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o lightnode

# Step 2: Runtime Stage
FROM alpine:latest

WORKDIR /app
COPY --from=builder /app/lightnode .

# Expose any ports if necessary (example: 8080)
EXPOSE 8080

CMD ["./lightnode"]
