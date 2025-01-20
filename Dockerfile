# syntax=docker/dockerfile:1

# Build stage: use native architecture and Go's cross-compilation
FROM --platform=$BUILDPLATFORM golang:1.23.5@sha256:51a6466e8dbf3e00e422eb0f7a97ac450b2d57b33617bbe8d2ee0bddcd9d0d37 AS build

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
FROM alpine:3.21.2@sha256:56fa17d2a7e7f168a043a2712e63aed1f8543aeafdcee47c58dcffe38ed51099

WORKDIR /bin

COPY --from=build /app/bin/testbed ./

# Run
ENTRYPOINT [ "/bin/testbed" ]
