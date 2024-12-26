# syntax=docker/dockerfile:1

# Build stage: use native architecture and Go's cross-compilation
FROM --platform=$BUILDPLATFORM golang:1.23.4@sha256:7ea4c9dcb2b97ff8ee80a67db3d44f98c8ffa0d191399197007d8459c1453041 AS build

# Set destination for COPY
WORKDIR /app

# For better layer caching, copy and install dependencies first then build app
COPY go.mod go.sum ./
RUN go mod download

# Note the slash at the end, as explained in
# https://docs.docker.com/engine/reference/builder/#copy
COPY . ./

# Set by docker automatically
ARG TARGETOS TARGETARCH
ARG GOOS=$TARGETOS
ARG GOARCH=$TARGETARCH
RUN make build

# Final stage
FROM alpine:3.21.0@sha256:21dc6063fd678b478f57c0e13f47560d0ea4eeba26dfc947b2a4f81f686b9f45

WORKDIR /bin

COPY --from=build /app/bin/testbed ./

# Run
ENTRYPOINT [ "/bin/testbed" ]
