# Security policy

## Supported versions

Only the latest release of this unofficial build receives fixes. Update through
the plugin repository in Silo, or upload the latest release binary. Security
problems in the official plugin belong to
[Silo-Server/silo-plugin-metadata-mdblist](https://github.com/Silo-Server/silo-plugin-metadata-mdblist).

## Reporting a vulnerability

Report security problems privately through
[GitHub's private vulnerability reporting](https://github.com/bulderi/silo-plugin-metadata-mdblist/security/advisories/new),
not in a public issue. Include the plugin version, the Silo version, and the
steps to reproduce. Never include a real MDBList API key; replace it with a
placeholder.

## What the plugin handles

- **Credentials.** Silo stores the MDBList API key encrypted as a secret plugin
  setting and passes it to the plugin when the plugin is configured. The plugin
  sends it only to MDBList, as the `apikey` query parameter MDBList requires,
  and redacts it from the errors and log lines it writes.
- **Network access.** The plugin talks only to `api.mdblist.com`.
- **Stored data.** The plugin keeps no state of its own. It holds the API key,
  the quota pause, and the learned batch limits in memory only.

A problem in any of these, such as the API key reaching a log line or a request
going to another host, is a security issue.
