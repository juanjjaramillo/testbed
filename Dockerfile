# syntax=docker/dockerfile:1

# Build stage
FROM golang:1.21 AS build

# Set by docker automatically
ARG TARGETOS TARGETARCH
ARG GOOS=$TARGETOS
ARG GOARCH=$TARGETARCH

# Set destination for COPY
WORKDIR /app

# Download Go modules
COPY go.mod go.sum ./
RUN go mod download

# Copy the source code. Note the slash at the end, as explained in
# https://docs.docker.com/engine/reference/builder/#copy
COPY . ./

# Build
RUN CGO_ENABLED=0 go build -o ./bin/testbed ./src

# Final stage
FROM alpine:3.18

WORKDIR /bin

COPY --from=build /app/bin/testbed .

# Run
CMD ["/bin/testbed", "--debug"]
