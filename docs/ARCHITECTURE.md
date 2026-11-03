# MoPM registry architecture

The v2 centralized registry index is [`index.json`](../index.json). Each published library version is one immutable ZIP-format file with the `.mopm` extension, stored under `packages/<name>/<version>.mopm`.

The index provides `schema=2`, package versions, latest release, artifact path, size, SHA-256 digest, exact dependencies and publisher. MoPM downloads the archive over HTTPS, verifies the digest and metadata, and installs Mojo source files.

Developers publish using `mopm publish NAME [VERSION]`. The native Mojo CLI packs the library from its manifest and sources. The GitHub transport adapter authenticates with the GitHub CLI, creates a branch in the registry (for the owner) or on a server-side fork (for other publishers), uploads the archive and updates the index through GitHub APIs, and opens a pull request. Publishers do not clone the registry.

Maintainers review and merge submissions. Automation checks archive validity, registered dependency references, and preservation of previously published version records.

`index.tsv` and raw `packages/greeter/*.mojo` are retained temporarily for legacy MoPM clients. New source packages are distributed in `.mopm` archives.
