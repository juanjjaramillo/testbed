# syntax=docker/dockerfile:1

# Build stage: use native architecture and Go's cross-compilation
FROM --platform=$BUILDPLATFORM golang:1.21.5@sha256:58e14a93348a3515c2becc54ebd35302128225169d166b7c6802451ab336c907 AS build

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
FROM alpine:3.18.5@sha256:34871e7290500828b39e22294660bee86d966bc0017544e848dd9a255cdf59e0

WORKDIR /bin

COPY --from=build /app/bin/testbed ./

# Run
ENTRYPOINT [ "/bin/testbed" ]
