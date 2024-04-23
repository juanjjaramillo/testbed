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
all: clean format modules lint test build lint-charts validate-helm-docs

.PHONY: clean
clean:
	rm -rf $(BIN_DIR) $(TMP_DIR)

.PHONY: format
format:
	go fmt ./...
	go vet ./...

.PHONY: modules
modules:
	@# Add any missing modules and remove unused modules in go.mod and go.sum
	go mod tidy
	@# Verify dependencies have not been modified since being downloaded
	go mod verify

.PHONY: lint
lint:
	golangci-lint run --config=./.github/.golangci.yml

.PHONY: test
test:
	mkdir $(TMP_DIR) || true
	go test -cover -covermode=count -coverprofile=$(TMP_DIR)/cover-unit.out ./...

.PHONY: integration
integration:
	mkdir $(TMP_DIR) || true
	CGO_ENABLED=0 go build -cover $(LDFLAGS) -o $(BIN_DIR)/testbed $(GO_DIR)
	GOCOVERDIR=$(TMP_DIR) bin/testbed
	GOCOVERDIR=$(TMP_DIR) bin/testbed -debug
	go tool covdata textfmt -i=$(TMP_DIR) -o $(TMP_DIR)/cover-integration.out
	go tool covdata percent -i=$(TMP_DIR)

.PHONY: build
build:
	CGO_ENABLED=0 go build $(LDFLAGS) -o $(BIN_DIR)/testbed $(GO_DIR)

.PHONY: coverprofile
coverprofile: test
	go tool cover -html=$(TMP_DIR)/cover-unit.out
	go tool cover -func=$(TMP_DIR)/cover-unit.out

.PHONY: coverprofile-integration
coverprofile-integration: integration
	go tool cover -html=$(TMP_DIR)/cover-integration.out
	go tool cover -func=$(TMP_DIR)/cover-integration.out

.PHONY: lint-charts
lint-charts:
	helm lint charts/**

.PHONY: validate-helm-docs
validate-helm-docs:
	@# Fail if changes have not been committed
	helm-docs
	git diff --exit-code -- charts/testbed/README.md

.PHONY: validate-modules
validate-modules: modules
	@# Fail if changes have not been committed
	git diff --exit-code -- go.sum go.mod
