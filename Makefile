GO_DIR = ./src
BIN_DIR = ./bin
TMP_DIR = ./tmp

.PHONE: all
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
	CGO_ENABLED=0 go build -o $(BIN_DIR)/testbed $(GO_DIR)

.PHONY: coverprofile
coverprofile:
	mkdir $(TMP_DIR) || true
	go test -coverprofile=$(TMP_DIR)/coverage.out ./...
	go tool cover -html=$(TMP_DIR)/coverage.out
	go tool cover -func=$(TMP_DIR)/coverage.out
