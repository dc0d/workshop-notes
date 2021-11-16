CVPKG=$(go list ./... | grep -v modeltest | tr '\n' ',')

.PHONY: test
test:
	clear
	go test -timeout 30s -count=1 -cover ./...

cover:
	clear
	go test -count=1 -timeout 10s -coverprofile=cover-profile.out -covermode=set -coverpkg=$(CVPKG) ./...
	go tool cover -html=cover-profile.out -o cover-coverage.html

cover-accp:
	clear
	RUN_TESTS=acceptance \
	go test -count=1 -timeout 10s -coverprofile=cover-profile.out -covermode=set -coverpkg=$(CVPKG) ./...
	go tool cover -html=cover-profile.out -o cover-coverage.html

cover-intg:
	clear
	RUN_TESTS=integration \
	go test -count=1 -timeout 10s -coverprofile=cover-profile.out -covermode=set -coverpkg=$(CVPKG) ./...
	go tool cover -html=cover-profile.out -o cover-coverage.html

cover-all:
	clear
	RUN_TESTS=acceptance,integration \
	go test -count=1 -timeout 10s -coverprofile=cover-profile.out -covermode=set -coverpkg=$(CVPKG) ./...
	go tool cover -html=cover-profile.out -o cover-coverage.html

lint:
	clear
	golangci-lint run ./...

gen:
	clear
	GOFLAGS=-mod=mod go generate ./...

wire:
	clear
	wire ./...

mod:
	clear
	go mod tidy
