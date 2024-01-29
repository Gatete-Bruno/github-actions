# Build stage
FROM golang:latest as build

WORKDIR /app
COPY go.mod ./
RUN go mod download

# Copy the necessary files of the application
COPY main.go .
COPY static ./static

# Build the binary of the app named "main"
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o main .

# 2nd stage, run the binary of the application
FROM alpine:latest

# Set working directory
WORKDIR /app

# Copy "main" binary and static folder into the current directory
COPY --from=build /app/main .
COPY --from=build /app/static ./static

EXPOSE 3000

# Execute the binary
CMD ["./main"]

