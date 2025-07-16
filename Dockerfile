# syntax=docker/dockerfile:1

# Build stage: use native architecture and Go's cross-compilation
FROM --platform=$BUILDPLATFORM golang:1.24.4@sha256:10c131810f80a4802c49cab0961bbe18a16f4bb2fb99ef16deaa23e4246fc817 AS build

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
FROM alpine:3.22.1@sha256:4bcff63911fcb4448bd4fdacec207030997caf25e9bea4045fa6c8c44de311d1

WORKDIR /bin

COPY --from=build /app/bin/testbed ./

# Run
ENTRYPOINT [ "/bin/testbed" ]
