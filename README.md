# MoPM Central Package Registry

The official centralized package registry for the Mojo Package Manager (MoPM).

## Install a package

```bash
mopm install greeter
```

Install a specific version:

```bash
mopm install greeter@1.0.0
```

MoPM downloads the package from the central registry, resolves its dependencies, and records the selected versions automatically. No separate project setup or registry configuration is required for a first-time install.

## Packages

Browse the [package index](index.tsv) and the [source packages](packages/).

## Publish a package

See [Contributing](docs/CONTRIBUTING.md) for package submission and registration instructions. The registry uses immutable Git commit references and validates submissions through GitHub Actions.

## About

MoPM's centralized registry is hosted on GitHub and maintained at `Dangujba/mopm-registry`.
