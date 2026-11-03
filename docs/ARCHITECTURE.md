# Architecture

MoPM uses one centralized, GitHub-hosted index (`index.tsv`) to discover packages. Each `name@version` entry identifies a source repository, full Git commit SHA, package subdirectory, and exact dependencies. Package source files currently live in this registry under `packages/<name>/`.

The client reads the index from GitHub, pins the source revision in `mopm.lock`, and installs sources into the project's vendor directory. No external registry database or server is required for v1.

The initial protocol supports public GitHub repositories and exact numeric versions. The current validator only permits packages hosted in `Dangujba/mopm-registry`. Later revisions may accept external package-source repositories subject to publisher checks, trusted metadata and reproducible validation.

A Git commit pin provides an immutable source revision, not an independent digest, signature, malware scan or safety guarantee.
