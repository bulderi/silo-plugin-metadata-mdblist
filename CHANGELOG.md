# Changelog

Notable changes to the unofficial Letterboxd build of the MDBList plugin.
Versions follow `version` in `manifest.json`, which is the official version
plus `-letterboxd`; each release is tagged `v<version>`. Changes to the
official plugin are listed in its
[releases](https://github.com/Silo-Server/silo-plugin-metadata-mdblist/releases).

## Unreleased

- Install from a plugin repository: `index.json` lists each platform binary
  with its SHA-256, so Silo installs the right binary and offers updates.
  Releases generate it and publish it on `main`.
- Releases run the CI checks first, use actions pinned to commit SHAs, and only
  publish from a tag that matches `manifest.json`.
- Added `SECURITY.md` and `CODEOWNERS`.

## 0.5.0-letterboxd — 2026-10-10

First release of this build, based on the official 0.5.0.

- Stores every rating MDBList has except Trakt's: Letterboxd, Metacritic
  critics and users, Roger Ebert and MyAnimeList besides the official
  plugin's IMDb, TMDB, Rotten Tomatoes and MDBList score, and declares the
  eight Silo can keep, Letterboxd first.
- `extras/silo-rating-logos.css` shows the IMDb and Letterboxd logos in the
  web app.
- Its own version suffix, publisher, and links; it keeps the plugin ID
  `silo.mdblist`, so it replaces the official plugin.
