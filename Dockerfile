# Base Docker Image: golang-builder
FROM golang:alpine as builder

ENV APP_NAME gokit-grpc-demo

# Make sure the Code is pulled
ENV /go/src/github.com/vnay92/${APP_NAME} "github.com/vnay92/*"
ENV CODE_DIR /go/src/github.com/vnay92/${APP_NAME}

# Make code directory as working directory
WORKDIR ${CODE_DIR}

# COPY go.mod file
ADD go.mod .

# COPY go.sum file
ADD go.sum .

RUN apk add \
        alpine-sdk \
        openssl-dev \
    && \
    go mod download

# Copy Code
COPY . .

RUN go build -o /bin/artifact


# Base Docker Image: golang
FROM golang:alpine

# Copy Artifact
COPY --from=builder /bin/artifact /bin/

# setting emtpy as the entrypoint
ENTRYPOINT []

# setting command
CMD ["/bin/artifact"]
