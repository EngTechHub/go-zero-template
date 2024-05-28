GOCMD=go
GOCTL=goctl
GOLINT=golangci-lint
GOLANGCI_LINT_VERSION=v1.53.0
GOBUILD=$(GOCMD) build
GOCLEAN=$(GOCMD) clean
APITEMP=./api
DEMO_SVC_NAME=demo

all: sample

sample:
	rm -rf $(DEMO_SVC_NAME)

	$(GOCTL) api new $(DEMO_SVC_NAME) --style go_zero --remote https://github.com/EngTechHub/go-zero-template # --home . 
	# modify main import
	sed -i '' '/$(DEMO_SVC_NAME)\/internal\/config/d' $(DEMO_SVC_NAME)/$(DEMO_SVC_NAME).go
	sed -i '' '/"github.com\/zeromicro\/go-zero\/core\/conf"/d' $(DEMO_SVC_NAME)/$(DEMO_SVC_NAME).go

	# copy template
	cp ${APITEMP}/etc.tpl $(DEMO_SVC_NAME)/etc/$(DEMO_SVC_NAME)-api-local.yaml
	cp ${APITEMP}/etc.tpl $(DEMO_SVC_NAME)/etc/$(DEMO_SVC_NAME)-api-dev.yaml
	cp ${APITEMP}/etc.tpl $(DEMO_SVC_NAME)/etc/$(DEMO_SVC_NAME)-api-staging.yaml
	cp ${APITEMP}/etc.tpl $(DEMO_SVC_NAME)/etc/$(DEMO_SVC_NAME)-api-prod.yaml

	# copy middleware
	rm -rf $(DEMO_SVC_NAME)/internal/middleware/*
	cp ./api/middleware/*.go $(DEMO_SVC_NAME)/internal/middleware/

	# copy Makefile
	sed 's/{.svcName}/$(DEMO_SVC_NAME)/g' ./Makefile.tpl > $(DEMO_SVC_NAME)/Makefile

	# go mod tidy
	cd $(DEMO_SVC_NAME) && $(GOCMD) mod tidy

run-sample:
	cd $(DEMO_SVC_NAME) && go run $(DEMO_SVC_NAME).go