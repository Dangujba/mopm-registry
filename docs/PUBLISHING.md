# Publishing Mojo libraries with MoPM

A publisher creates **one** `package.mopact` manifest and runs `mopm publish NAME`. There is no need to clone or manually edit `mopm-registry`.

## Library directory

```text
greeter/
├── package.mopact
└── src/
    ├── __init__.mojo
    └── greet.mojo
```

`package.mopact`:

```text
library greeter 1.2.0
for mojo 1.2.0
from src
about Simple greetings for Mojo
license MIT
```

See the [MoPact syntax specification](MoPact.md).

## Commands

Once the native publisher is compiled and verified:

```sh
mopm login                  # one-time GitHub authentication
mopm publish greeter       # version 1.2.0 from package.mopact
mopm publish greeter 1.2.1 # explicitly choose another release version
```

MoPM will package source into `greeter-1.2.0.mopm`, compute a SHA-256 hash and submit a registry pull request through the GitHub API without cloning the registry. Publishing does not become public until review and merge. New versions are immutable.

## Archive content

```text
greeter-1.2.0.mopm
├── package.mopact
└── src/
    ├── __init__.mojo
    └── greet.mojo
```

Earlier archives using `mopm.json` remain immutable and readable. A new `package.mopact` archive validator and compatible installer are required before this new package format is accepted for production.

The centralized [`index.json`](../index.json) is package discovery metadata, not something developers write by hand. No `.mojoc` compiler-version-specific binaries are distributed in this initial source-only package format.

## Security

Publishing will require package-owner identity, maintainer review and CI checks. Package archives must be verified for digest mismatch, symlinks, path traversal, malicious assets and unsafe extraction. A registry listing is not a safety endorsement.
