# Go parameters
GOCMD = go
GOBUILD = $(GOCMD) build
GOCLEAN = $(GOCMD) clean
GOTEST = $(GOCMD) test
GOGET = $(GOCMD) get

# Name of the binary output
BINARY_NAME = az-mpf

# Main source file
# MAIN_FILE = main.go

# Output directory for the binary
OUTPUT_DIR = .

all: clean build

build:
	@echo "Building $(BINARY_NAME)..."
	@mkdir -p $(OUTPUT_DIR)
	$(GOBUILD) -o $(OUTPUT_DIR)/$(BINARY_NAME) ./cmd

test:
	@echo "Running tests..."
	$(GOTEST) -v ./pkg/domain ./pkg/infrastructure/ARMTemplateShared ./pkg/infrastructure/mpfSharedUtils 

clean:
	@echo "Cleaning..."
	$(GOCLEAN)
	@rm -rf $(OUTPUT_DIR)

run: build
	@echo "Running $(BINARY_NAME)..."
	@./$(OUTPUT_DIR)/$(BINARY_NAME)

deps:
	@echo "Fetching dependencies..."
	$(GOGET) ./...

.PHONY: all build test clean run deps

# build for darwin arm64, darwin amd64, linux amd64, and windows amd64
build-all:
	@echo "Building $(BINARY_NAME) for all target platforms..."
	@mkdir -p $(OUTPUT_DIR)
	GOOS=darwin GOARCH=arm64 $(GOBUILD) -o $(OUTPUT_DIR)/$(BINARY_NAME)-darwin-arm64 ./cmd
	GOOS=darwin GOARCH=amd64 $(GOBUILD) -o $(OUTPUT_DIR)/$(BINARY_NAME)-darwin-amd64 ./cmd
	GOOS=linux GOARCH=amd64 $(GOBUILD) -o $(OUTPUT_DIR)/$(BINARY_NAME)-linux-amd64 ./cmd
	GOOS=windows GOARCH=amd64 $(GOBUILD) -o $(OUTPUT_DIR)/$(BINARY_NAME)-windows-amd64.exe ./cmd

test-e2e:
	@echo "Running end-to-end tests..."
	$(GOTEST) -v ./e2eTests

