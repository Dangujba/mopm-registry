# Publishing libraries to MoPM

Each published library is one versioned `.mopm` file in the centralized GitHub repository.

## 1. Prepare your Mojo library

A sample layout:

```text
mylibrary/
├── mojo.toml
└── src/
    └── mylibrary/
        ├── __init__.mojo
        └── helpers.mojo
```

The `[package]` section in `mojo.toml` supplies `name` and `version`:

```toml
[package]
name = "mylibrary"
version = "1.2.0"
mojo = "1.2.0"
```

## 2. Publish

Authenticate with GitHub once:

```bash
mopm login
```

Then, from your package directory:

```bash
mopm publish mylibrary
```

Or explicitly select a release version:

```bash
mopm publish mylibrary 1.2.1
```

MoPM finds and validates the library manifest and `__init__.mojo`, builds the `.mopm` ZIP-compatible archive, computes the SHA-256 checksum and submits a GitHub pull request. The CLI uses the GitHub API, with a server-side fork when needed; no local clone is necessary.

The registry maintainer reviews the pull request and validation checks before merging. A package is not publicly available until the pull request is merged.

## Archive specification

```text
mylibrary-1.2.0.mopm
├── mopm.json
└── src/
    ├── __init__.mojo
    └── helpers.mojo
```

`mopm.json` records the name, version, Mojo compatibility version, and exact dependencies. The centralized `index.json` records the version, artifact path, size, SHA-256 checksum and publisher.

Precompiled `.mojoc` files are not distributed in this source-only format because their compiler compatibility is version-specific.

## Review and security

Published versions cannot be replaced. The registry validates archive contents, metadata and checksums. Packages are untrusted code: consumers should review third-party packages and should not assume that a registry listing constitutes a security audit.
