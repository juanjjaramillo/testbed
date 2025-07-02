# syntax=docker/dockerfile:1

# Build stage: use native architecture and Go's cross-compilation
FROM --platform=$BUILDPLATFORM golang:1.24.4@sha256:20a022e5112a144aa7b7aeb3f22ebf2cdaefcc4aac0d64e8deeee8cdc18b9c0f AS build

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
FROM alpine:3.22.0@sha256:8a1f59ffb675680d47db6337b49d22281a139e9d709335b492be023728e11715

WORKDIR /bin

COPY --from=build /app/bin/testbed ./

# Run
ENTRYPOINT [ "/bin/testbed" ]
