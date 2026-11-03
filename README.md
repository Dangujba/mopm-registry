# MoPM Central Package Registry

The official centralized GitHub-hosted registry for the native Mojo Package Manager (MoPM).

Registry owner: `Dangujba`. Default branch: `main`.

The canonical package index is [`index.tsv`](index.tsv). Package sources live under `packages/`. Package versions are immutable and pinned to full Git commit SHAs. The registry's CI validates entries, dependencies and package source structure.

## Installing a package (after MoPM CLI compilation)

```sh
mopm init myapp
cd myapp
mopm search greeter
mopm add greeter@1.0.0
mopm install --locked
```

MoPM CLI compatibility and native compilation are **not yet verified**. The sample `greeter@1.0.0` package is registered in `index.tsv` at an immutable source commit. The native MoPM CLI is not yet compiler-tested.

## Contributing

Submit a pull request with a new package source in `packages/<name>/`, followed by a separate commit or pull request for the immutable index entry. See `docs/CONTRIBUTING.md` and `docs/ARCHITECTURE.md`.

This registry is experimental. Only review and run code from packages you trust.
