# Directories
GO_DIR = ./src
BIN_DIR = ./bin
TMP_DIR = ./tmp

# Build-time metadata
COMMIT ?= $(shell git rev-parse HEAD || echo "N/A")
DATE := $(shell date)
VERSION ?= $(shell git describe --abbrev=0 --tags $(git rev-list --tags --max-count=1) || echo "N/A")

# Import path for Go module
MODULE = github.com/juanjjaramillo/testbed
IMPORT = $(MODULE)/src

# Linker flags
LDFLAGS ?= -ldflags="-X '$(IMPORT)/utils.commit=$(COMMIT)' -X '$(IMPORT)/utils.date=$(DATE)' -X '$(IMPORT)/utils.version=$(VERSION)'"

.PHONY: all
all: clean format test build

.PHONY: clean
clean:
	rm -rf $(BIN_DIR) $(TMP_DIR)
	go mod tidy

.PHONY: format
format:
	go fmt ./...
	go vet ./...

.PHONY: test
test:
	go test -cover ./...

.PHONY: build
build:
	CGO_ENABLED=0 go build $(LDFLAGS) -o $(BIN_DIR)/testbed $(GO_DIR)

.PHONY: coverprofile
coverprofile:
	mkdir $(TMP_DIR) || true
	go test -coverprofile=$(TMP_DIR)/coverage.out ./...
	go tool cover -html=$(TMP_DIR)/coverage.out
	go tool cover -func=$(TMP_DIR)/coverage.out
