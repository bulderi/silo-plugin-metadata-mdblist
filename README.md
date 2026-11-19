# MDBList ratings plugin for Silo (Letterboxd build)

> [!WARNING]
> This is an unofficial fork of the official
> [MDBList plugin](https://github.com/Silo-Server/silo-plugin-metadata-mdblist),
> not made or endorsed by Silo, MDBList, or any rating service. It fetches
> ratings with your own MDBList API key, and the rating services' terms apply
> to how you use them.

Adds Letterboxd ratings to Silo's title pages, and stores every other rating
MDBList has, from the IMDb or TMDB ID your primary metadata provider already
matched. It runs below TMDB in a library's metadata provider chain and fills
only what TMDB left empty.

## Ratings

| Rating | Scale | Official plugin |
|---|---|---|
| IMDb | 10 | Yes |
| TMDB | 10 | Yes |
| **Letterboxd** | 5, like `Letterboxd 4.0` | No |
| Rotten Tomatoes critics | % | Yes |
| Rotten Tomatoes audience | % | Yes |
| Metacritic critics (Metascore) | 100 | No |
| Metacritic users | 10 | No |
| Roger Ebert | 4 stars | No |
| MyAnimeList | 10 | No |
| MDBList score | 100 | Yes |

A title page shows IMDb and TMDB, then the ratings an administrator turns on
under **Settings > Library & Metadata > Ratings**, each only when the title has
it. The others are stored and stay hidden. Trakt's rating is left out: Trakt
has blocked MDBList's API access, so MDBList's figure is stale or missing.

The plugin also fills in the release certification, the Common Sense Media
minimum age, and year, release date, runtime (movies only), original language,
genres, and show status.

## How it differs from the official plugin

Checked against the official 0.5.2.

- **More ratings.** It stores Letterboxd, Metacritic critics and users, Roger
  Ebert, and MyAnimeList as well, and declares eight rating sources to Silo,
  Letterboxd first. The official plugin declares three: the two Rotten Tomatoes
  scores and MDBList's.
- **Rating logos.** `extras/silo-rating-logos.css` shows the IMDb and
  Letterboxd logos in the web app (see [Rating logos](#rating-logos)).
- **Its own plugin.** Its plugin ID is `bulderi.mdblist-letterboxd`, its
  version ends in `-letterboxd`, and its links point to this fork, so Silo
  lists it under **Other sources**, separately from the official plugin.
- **Its own releases.** Silo installs and updates it from this repository's
  `index.json`. Releases are signed by this repository's workflow instead of
  Silo's shared release workflow.
- **A newer SDK.** It builds against `silo-plugin-sdk` v0.24.0 and starts
  through the SDK's manifest bootstrap; the official 0.5.2 uses v0.16.1.

## Install

1. In Silo, open the administrator **Plugins** page, select **Catalog**, and
   click **Add repository** with this URL:

   ```text
   https://raw.githubusercontent.com/bulderi/silo-plugin-metadata-mdblist/main/index.json
   ```

2. If the official **MDBList Ratings** plugin is installed, remove it. Both
   declare the same rating sources, so run only one.
3. Find **MDBList Ratings** by bulderi under **Other sources** and click
   **Install**.

New releases show up as updates in Silo. Binaries are published for Linux
amd64, Linux arm64, macOS arm64, FreeBSD amd64, and FreeBSD arm64.

### Moving from a build with the ID `silo.mdblist`

Before 0.5.1-letterboxd this build used the official plugin's ID, so Silo
treats the current one as a new plugin:

1. Remove the installed `silo.mdblist` plugin.
2. Install this one from the catalog, as above.
3. Paste your MDBList API key into its settings again.
4. Check its place in each library's provider chain, as under [Setup](#setup).

Ratings already stored stay, because Silo keeps them per rating source, not per
plugin.

## Setup

1. Create an API key in your [MDBList](https://mdblist.com) preferences.
2. Paste it into the plugin's settings. Without a key the plugin stays idle.
3. Check that **MDBList** sits *below* the primary provider, such as TMDB, in
   each movie and series library's metadata provider chain. Silo usually puts
   it there on install.
4. Turn on **Letterboxd**, and only Letterboxd, under **Settings > Library &
   Metadata > Ratings**.
5. Run **Bulk Metadata Enrichment** under the admin's scheduled tasks, or wait
   for its hourly run, to look up the titles already in your libraries.

## Good to know

- **Turn on only Letterboxd.** A title page shows at most three ratings: IMDb,
  TMDB, then the turned-on sources in declaration order. Silo's built-in NFO
  provider comes first and declares Rotten Tomatoes, Metacritic, Trakt, and
  TheTVDB ahead of Letterboxd, so turning on any of them can push Letterboxd
  off the page. The logo CSS assumes Letterboxd is the only one, too.
- **It never identifies a title.** It looks titles up by the IMDb or TMDB ID
  another provider matched, and returns nothing without one. Its search always
  returns no results.
- **It only fills blanks.** Silo keeps the first provider's value for each
  field. Keywords and countries are never sent, because Silo adds list fields
  from every provider together instead of filling a blank.
- **The free tier goes a long way.** MDBList allows 1000 requests a day for
  free. Lookups that arrive together go out as one request for up to 100
  titles.
- **A spent quota pauses the plugin, not Silo.** It stops asking MDBList until
  the quota resets (00:00 UTC for the daily quota), and Silo looks those titles
  up again later. A metadata refresh never fails because of MDBList.
- **A 0% Rotten Tomatoes score shows as no score.** Silo treats zero as unrated.
- **Showing Letterboxd needs a Silo server from 2026-10-01 or later** (the
  `latest` image). An older server stores the ratings but shows only IMDb and
  Rotten Tomatoes.

## Rating logos

`extras/silo-rating-logos.css` replaces the IMDb and Letterboxd text marks with
their official logos, as tall as TMDB's, on title pages, the home hero, the
Watch Tonight card, and the Watch Together picker. The logos are embedded in
the file, so no request leaves the page; the source files are in
`extras/logos` and are their owners' trademarks.

Silo's markup does not name a rating's source, so the CSS goes by position:
any other rating you turn on gets the Letterboxd logo. A lone text mark that
could be either keeps its text, and if Silo changes its markup, the text shows
again.

Load the file in one of these ways:

- **Your reverse proxy** serves the file and makes the page load it, for every
  user and across Silo updates. Stock Caddy can do it with the block below. A
  proxy that rewrites responses, such as nginx with `sub_filter`, can instead
  add `<link rel="stylesheet" href="/silo-custom/rating-logos.css">` before
  `</head>`. Silo's Content-Security-Policy still applies: it allows the
  same-origin stylesheet and blocks scripts.
- **A browser extension** for user styles, such as Stylus, with the file's
  contents and your Silo address as the site. It works only in browsers where
  you install it.

### Stock Caddy

Silo's page links one stylesheet, `/assets/index-<hash>.css`. Caddy answers
that URL with two `@import` rules, one for Silo's own file and one for the
logos, so Silo's HTML and headers stay untouched. Put the CSS at
`/etc/caddy/silo-custom/rating-logos.css`:

```caddy
silo.example.com {
	handle /silo-custom/rating-logos.css {
		header Cache-Control "no-cache"
		root * /etc/caddy
		file_server
	}

	@main_css {
		path_regexp ^/assets/index-[A-Za-z0-9_-]+\.css$
		not query orig=1
	}
	handle @main_css {
		header Content-Type "text/css; charset=utf-8"
		header Cache-Control "public, max-age=3600"
		respond * `@import url("{re.main_css.0}?orig=1");
@import url("/silo-custom/rating-logos.css");
` 200
	}

	handle {
		reverse_proxy silo:8080
	}
}
```

Keep `{re.main_css.0}`: it is the cleaned match, while the raw request path
would put text from the request into the response. Keep `respond *` too,
because Caddy reads a body that starts with `@` as a matcher.

Silo marks its stylesheet as cacheable for a year, so a browser that already
has it shows the logos only after a hard reload or the next Silo build. If a
Silo build renames the file, the rule stops matching and the text marks return.

---

## For developers

- **Plugin ID:** `bulderi.mdblist-letterboxd`
- **Capability:** `metadata_provider.v1`, id `mdblist`, with
  `lookup_provider_ids: ["imdb", "tmdb"]` and `bulk_lookup_limit: 100`
- Builds against `silo-plugin-sdk` v0.24.0 and starts through
  `runtime.ServeManifestWithOptions`, which validates the manifest, stamps the
  version and the binary's checksum, and answers `plugin manifest`.
- Showing declared rating sources needs
  [Silo-Server/silo-server#1697](https://github.com/Silo-Server/silo-server/pull/1697)
  and [#1698](https://github.com/Silo-Server/silo-server/pull/1698). A server
  that ignores `lookup_provider_ids` never calls the plugin, and one without
  the bulk enrichment pass logs a warning per lookup while the key is missing
  or rejected, the quota is spent, or MDBList is down.

### What it maps

| MDBList | Silo |
| --- | --- |
| `ratings[source=imdb]` | `rating_imdb` (0-10) |
| `ratings[source=tmdb]` | `rating_tmdb` (0-10) |
| `ratings[source=tomatoes]` | `rating_rt_critic` (0-100) |
| `ratings[source=popcorn\|tomatoesaudience\|audience]` | `rating_rt_audience` (0-100) |
| every source above plus Letterboxd, Metacritic, Roger Ebert and MyAnimeList, and the top-level `score` | `ratings.sources` (0-100 with vote counts) |
| `certification` | content rating |
| `age_rating` + `commonsense` | `advisory_age` / `advisory_source` |
| `year` | year |
| `released` | release date (movies) or first air date (shows) |
| `runtime` | runtime (movies only; a show's figure is not per episode) |
| `language` | original language |
| `genres` | genres |
| `status` | show status (shows only; the host normalises the spelling) |

Nothing else. Titles, overviews, taglines, artwork, trailers, and external IDs
belong to the primary provider: MDBList's text is English only, the host keeps
every provider's trailers, and an enrichment-only provider must not hand the
host identity it did not verify. MDBList's `ids` object is read only to match
batch answers to requests. Its keywords are slugs mixed with MDBList's own
tags, such as `has-trailer` and `2k-blu-ray`.

MDBList reports each rating twice: `value` on the source's own scale and
`score` normalised to 0-100. The scales are not uniform (IMDb's `value` is out
of 10, TMDB's, Rotten Tomatoes' and Metacritic's out of 100, Letterboxd's
doubled to 10, Roger Ebert's out of 4), so `score` is the input wherever it is
present, and the per-source conversion is pinned to
`provider/testdata/movie_jaws.json`.

The ratings Struct carries the four flat keys plus a `sources` object:

```json
{
  "imdb": 8.1, "tmdb": 7.6, "rt_critic": 97,
  "sources": {
    "imdb":       {"score": 81, "votes": 673852},
    "tmdb":       {"score": 76, "votes": 10114},
    "rt_critic":  {"score": 97, "votes": 102},
    "letterboxd": {"score": 80, "votes": 876082},
    "metacritic": {"score": 87, "votes": 21},
    "rogerebert": {"score": 100},
    "mdblist":    {"score": 86}
  }
}
```

Keys are `imdb`, `tmdb`, `letterboxd`, `rt_critic`, `rt_audience`,
`metacritic`, `metacritic_user`, `rogerebert`, `myanimelist`, and `mdblist`.
Every `score` is 0-100, and `votes` is omitted when MDBList has no count. Silo
names IMDb and TMDB itself and keeps another key only if the capability
declares it under `rating_sources`, with the short name clients show, a label,
and its scale. Eight is the most Silo keeps per capability. Servers that
predate per-source storage skip `sources`. The Common Sense age rides in the
free-form metadata map under `advisory_age` and `advisory_source`.

### Rate limits and failures

MDBList meters requests per day (1000 free, then 10k, 25k, 100k, and 250k by
paid tier, resetting at 00:00 UTC) and caps every tier at 1000 reads per fixed
five-minute window.

- **Batching.** Lookups for the same route (IMDb or TMDB, movie or show) that
  arrive within 250 ms go out as one request to MDBList's batch endpoint, up to
  100 IDs. A lookup with no partner uses the single-title request. If MDBList
  refuses a batch, the plugin retries it in halves and, when both halves go
  through, remembers the smaller limit for that route. TMDB IDs are preferred
  because the batch endpoint's schema types IDs as integers.
- **Quota pause.** After a 429 the plugin sends nothing until `Retry-After`,
  or 00:00 UTC for the daily quota. After `X-RateLimit-Remaining: 0` it pauses
  until `X-RateLimit-Reset`. Saving a different API key lifts the pause.
- **Pacing.** A client-side limiter keeps requests at three a second, under the
  five-minute cap.

A title MDBList does not know is an empty answer. Every other failure is a gRPC
status, so Silo can tell "nothing to find" from "ask again later":

| Failure | Status |
|---|---|
| Quota or burst limit spent, including while paused | `RESOURCE_EXHAUSTED` |
| No API key configured | `FAILED_PRECONDITION` |
| Key rejected (HTTP 401 or 403) | `UNAUTHENTICATED` |
| Outage: unreachable, HTTP 5xx, an error body answering a batch | `UNAVAILABLE` |
| MDBList refused or garbled one title's answer, including an error body | `INTERNAL` |

The plugin logs each failed request, and a quota pause once when it begins. It
does not log a missing key.

### Build and test

```sh
make test        # go test -race ./...
make build       # host platform
make build-all   # dist/ binaries for linux/amd64, linux/arm64, darwin/arm64, freebsd/amd64, freebsd/arm64
```

The build takes its version from `manifest.json`, so Silo's plugin admin shows
which build is installed. [CONTRIBUTING.md](CONTRIBUTING.md) lists the checks
to run before a pull request.

### Release

Bump `version` in `manifest.json`, add the changes to
[CHANGELOG.md](CHANGELOG.md), and push a matching tag, `v` plus the version;
there is no automatic version bump. The release workflow takes the release
notes from the version's CHANGELOG section, runs the CI checks, builds every
platform, signs the binaries with a GitHub build provenance attestation, and
publishes them with `checksums.txt`, the signature bundle
`plugin.sigstore.json`, and `index.json`, written by `cmd/genindex`. It then
commits that `index.json` to `main`, which is the file the install URL serves.

Silo compares versions segment by segment and compares a segment with the
suffix as text, so it would rank `0.5.10-letterboxd` below `0.5.9-letterboxd`
and offer no update. Move to the next minor version instead of a two-digit
patch.

Each release from 0.5.2-letterboxd on is signed. Silo verifies that this
repository's release workflow built the binary from the version's tag and shows
the installation as verified. To check a download yourself:

```sh
gh attestation verify plugin-linux-amd64 \
  --repo bulderi/silo-plugin-metadata-mdblist \
  --source-ref refs/tags/v<version>
```

### Keeping up with the official plugin

This fork is the official plugin plus its own commits: the plugin changes, the
logo CSS, the install index and its release tooling, and the index commits the
release workflow adds. With the official repository as the `upstream` remote,
move them onto a new official version with a rebase, run the tests, set the
version to the official one plus `-letterboxd`, and push:

```sh
git fetch upstream
git rebase upstream/main
GOWORK=off go test -race ./...
git push --force-with-lease origin main
```

## Contributing

Read [CONTRIBUTING.md](CONTRIBUTING.md) before opening a pull request.

## License

AGPL-3.0-only.
