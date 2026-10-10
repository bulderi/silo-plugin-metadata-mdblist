# Contributing to the MDBList Ratings Plugin (unofficial Letterboxd build)

The [Silo contribution guide](https://github.com/Silo-Server/.github/blob/main/CONTRIBUTING.md)
covers project-wide coordination, focused changes, evidence, AI disclosure, and
pull request expectations. Those requirements apply here; this guide adds the
plugin-specific workflow.

## Before you start

This repository is a fork of
[`Silo-Server/silo-plugin-metadata-mdblist`](https://github.com/Silo-Server/silo-plugin-metadata-mdblist).
It owns only the changes that make this build differ: the rating sources it
reports and declares, its version suffix and links, and the web CSS in
`extras/`. Fixes that apply to the official plugin belong upstream. Plugin
contracts belong in
[`silo-plugin-sdk`](https://github.com/Silo-Server/silo-plugin-sdk), and host
metadata merging and rating display belong in
[`silo-server`](https://github.com/Silo-Server/silo-server).

Open an [issue](https://github.com/bulderi/silo-plugin-metadata-mdblist/issues)
before changing which rating sources the plugin reports or declares, their
order, or the advertised capability. Silo keeps at most eight declared rating
sources per capability and shows them in declaration order, and
`extras/silo-rating-logos.css` assumes Letterboxd is the only source turned on
beyond IMDb and TMDB.

## Development setup

Use the Go version declared in `go.mod`. A local `go.work` may point at a sibling
SDK checkout while developing both repositories, but committed code and CI must
resolve the tagged SDK dependency with `GOWORK=off`. Never commit real MDBList
API keys, deployment URLs, captured responses from a private library, or a
local filesystem `replace` directive.

## Validate your change

```sh
GOWORK=off go test -race ./...
GOWORK=off go vet ./...
GOWORK=off go build ./...
GOWORK=off go run . manifest >/dev/null
gofmt -l .
golangci-lint run ./...
```

The manifest command must exit successfully, and `gofmt -l .` and
`golangci-lint` must report nothing. A new rating source needs a mapping in
`provider/provider.go`, a declaration in `manifest.json` (the manifest test
fails when the two disagree), and a pinned value scale if MDBList sends it
without a score.

## Keep up with the official plugin

The fork is the official plugin plus two commits: the plugin changes and the
logo CSS. Rebase them onto each new official release, rerun the validation
above, and set `manifest.json`'s version to the official version plus
`-letterboxd` before tagging a release.

## Open the pull request

Use a Conventional Commit title, explain any change to which ratings Silo
stores or shows, and paste the actual validation results. Read the
[AI-assisted contribution policy](https://github.com/Silo-Server/silo-server/blob/main/docs/ai-contributions.md)
and include its disclosure block.
