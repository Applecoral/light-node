# Step 1: Build Stage
FROM golang:1.23 AS builder

WORKDIR /app

# Copy and download dependencies
COPY go.mod go.sum ./
RUN go mod tidy && go mod download

# Copy the entire application and build
COPY . .
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o lightnode . || (echo "Build failed"; exit 1)
# Step 2: Runtime Stage
FROM alpine:latest

WORKDIR /app
COPY --from=builder /app/lightnode .

CMD ["./lightnode"]
