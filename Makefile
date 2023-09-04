GO_DIR = ./src
BIN_DIR = ./bin

.PHONE: all
all: clean test build

.PHONY: clean
clean:
	rm -rf $(BIN_DIR)
	rm -f *.out
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
	go build -o $(BIN_DIR)/testbed $(GO_DIR)

.PHONY: coverprofile
coverprofile:
	go test -coverprofile=coverage.out ./...
	go tool cover -html=coverage.out
	go tool cover -func=coverage.out
	rm -f coverage.out
