.PHONY: build build-all test lint clean logos

BINARY=plugin
PLATFORMS=linux/amd64 linux/arm64 darwin/arm64 freebsd/amd64 freebsd/arm64
# This unofficial build takes its version from manifest.json, not from
# upstream's tags, so Silo shows which build is installed.
VERSION ?= $(shell sed -n 's/^  "version": "\(.*\)",$$/\1/p' manifest.json)
LDFLAGS=-s -w -X main.version=$(VERSION)

build:
	go build -trimpath -ldflags="$(LDFLAGS)" -o $(BINARY) .

test:
	go test -race ./...

lint:
	golangci-lint run ./...

clean:
	rm -rf $(BINARY) dist

logos:
	python3 extras/font/build.py

build-all:
	@mkdir -p dist
	@set -e; for platform in $(PLATFORMS); do \
		GOOS=$${platform%%/*} GOARCH=$${platform##*/} CGO_ENABLED=0 \
		go build -trimpath -ldflags="$(LDFLAGS)" -o dist/$(BINARY)-$${platform%%/*}-$${platform##*/} .; \
	done
