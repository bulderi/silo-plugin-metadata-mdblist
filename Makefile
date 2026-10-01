.PHONY: build build-all test lint clean

BINARY=plugin
PLATFORMS=linux/amd64 linux/arm64 darwin/arm64
# This unofficial build takes its version from manifest.json (0.5.0-letterboxd),
# not from upstream's tags, so Silo shows which build is installed.
VERSION ?= $(shell sed -n 's/^  "version": "\(.*\)",$$/\1/p' manifest.json)
LDFLAGS=-s -w -X main.version=$(VERSION)

build:
	go build -trimpath -ldflags="$(LDFLAGS)" -o $(BINARY) .

test:
	go test ./...

lint:
	golangci-lint run ./...

clean:
	rm -f $(BINARY)

build-all:
	@for platform in $(PLATFORMS); do \
		GOOS=$${platform%%/*} GOARCH=$${platform##*/} CGO_ENABLED=0 \
		go build -trimpath -ldflags="$(LDFLAGS)" -o dist/$(BINARY)-$${platform%%/*}-$${platform##*/} .; \
	done
