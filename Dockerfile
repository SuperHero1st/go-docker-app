# Use the official Go image as the base image
FROM golang:1.21-alpine AS builder

# Set the working directory inside the container
WORKDIR /app

# Copy the Go source code
COPY main.go .

# Build the Go application
RUN go build -o user-api main.go

# Use a minimal Alpine image for the final stage
FROM alpine:latest

# Install ca-certificates for HTTPS requests
RUN apk --no-cache add ca-certificates

# Set the working directory
WORKDIR /root/

# Copy the binary from the builder stage
COPY --from=builder /app/user-api .

# Create the users_saved directory
RUN mkdir -p users_saved

# Expose port 8080
EXPOSE 8080

# Run the application
CMD ["./user-api"]
