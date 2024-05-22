GOCMD=go
GOCTL=goctl
GOLINT=golangci-lint
GOLANGCI_LINT_VERSION=v1.53.0
GOBUILD=$(GOCMD) build
GOCLEAN=$(GOCMD) clean
BINARY_NAME={.svcName}

# 默认目标
all: build

genapi:
	$(GOCTL) api format --dir .
	$(GOCTL) api go --api {.svcName}.api --style go_zero --dir .

# 编译目标
build: genapi
	$(GOBUILD) -o $(BINARY_NAME) -v 

# 清理目标
clean:
	$(GOCLEAN)
	rm -f $(BINARY_NAME)

# 运行目标
run:
	$(GOBUILD) -o $(BINARY_NAME) -v
	./$(BINARY_NAME)


lint-install:
	@if ! golangci-lint --version >/dev/null 2>&1; then \
		echo "golangci-lint not found. Installing golangci-lint $(GOLANGCI_LINT_VERSION)"; \
		curl -sSfL https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh | sh -s -- -b $(go env GOPATH)/bin $(GOLANGCI_LINT_VERSION) \
	else \
		echo "golangci-lint $(GOLANGCI_LINT_VERSION) is already installed"; \
	fi


# lint
lint: lint-install
	$(GOLINT) -v run ./...


lintfix: lint-install
	$(GOLINT) run --fix
