# Changelog

Notable changes to MDBList Ratings Plus, an unofficial build of the MDBList
plugin, called the Letterboxd build before 0.5.2-plus. Versions follow
`version` in `manifest.json`, which is the official version plus `-plus`
(`-letterboxd` before 0.5.2-plus), then `.1`, `.2` and so on for releases with
only this build's changes; each release is tagged `v<version>`. Changes to the
official plugin are listed in its
[releases](https://github.com/Silo-Server/silo-plugin-metadata-mdblist/releases).

## 0.5.2-plus.1 — 2026-11-20

Based on the official 0.5.2.

- A title keeps its ratings when MDBList sends one field with an unexpected
  type, such as a quoted year. Only that field is left empty.
- When a batch answer cannot be matched to a requested ID, the titles left
  unanswered are looked up one by one. Before, Silo recorded them as unknown
  to MDBList and did not ask again for weeks.
- A batch size lowered after MDBList refused a batch now resets after a day.
  Before, a passing refusal could turn batching off until the plugin
  restarted, which multiplied the requests a library costs.

## 0.5.2-plus — 2026-11-19

Based on the official 0.5.2.

- The build is now MDBList Ratings Plus: plugin ID `bulderi.mdblist-plus` and
  versions ending in `-plus`, because it adds more than Letterboxd. Silo
  treats it as a new plugin: follow "Moving from an earlier build" in the
  README.

## 0.5.2-letterboxd.1 — 2026-11-19

Based on the official 0.5.2. The plugin itself is unchanged; this release
updates the logo CSS in `extras/`.

- `extras/silo-rating-logos.css` draws the logos with a font instead of by
  position: Silo's own Plus Jakarta Sans, in which "IMDb" and "Letterboxd"
  are ligatures drawn as the logos. Each logo now lands on its own rating
  whichever ratings are turned on, and other sources keep their text.
- The logo CSS also draws Rotten Tomatoes (critics and audience), Metacritic
  (critics and users), MyAnimeList and MDBList. Audience and user scores show
  the brand's logo followed by "Audience" or "Users". A logo replaces only a
  whole source name. Compact icons draw taller than the wordmarks, so every
  logo looks about the same size. A browser without colour fonts draws each
  logo's outline instead of a solid shape.

## 0.5.2-letterboxd — 2026-11-19

Based on the official 0.5.2.

- Binaries for FreeBSD amd64 and arm64, from the official plugin.
- Releases are signed with a GitHub build provenance attestation, and
  `index.json` lists the bundle, so Silo shows the installation as verified.
  The official plugin's signed release workflow signs as Silo-Server and needs
  its catalog secret, so this build signs with its own.
- A release's notes are its section of this changelog, and a tag without one
  is not released.
- Builds against `silo-plugin-sdk` v0.35.0, up from v0.24.0.

## 0.5.1-letterboxd — 2026-11-09

- The plugin ID is now `bulderi.mdblist-letterboxd`, so Silo lists this build
  under **Other sources** and installs it from the catalog. Silo treats it as a
  new plugin: follow "Moving from a build with the ID `silo.mdblist`" in the
  README.
- The README explains how to load `extras/silo-rating-logos.css`: through your
  reverse proxy, with a block for stock Caddy, or a browser extension, instead
  of Admin > Appearance.
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
