# Build stage
FROM golang:latest as build

WORKDIR /app
COPY go.mod ./
RUN go mod download

# Copy the necessary files of the application
COPY main.go .

# Build the binary of the app named "main"
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o main .

# 2nd stage, run the binary of the application
FROM golang:latest

WORKDIR /app

# Copy "main" binary
COPY --from=build /app/main .

# Copy static folder into the current dir
COPY ./static /app/static

EXPOSE 3000

# Execute the binary
CMD ["./main"]

