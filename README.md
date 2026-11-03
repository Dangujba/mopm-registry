# MoPM Central Package Registry

The official centralized package registry for Mojo libraries. Packages are published as versioned **`.mopm`** archives, indexed in [`index.json`](index.json).

## Install a library

```bash
mopm install greeter
```

To install an exact version:

```bash
mopm install greeter@1.0.1
```

## Publish a library

From your Mojo library's folder:

```bash
mopm publish mylibrary
```

MoPM detects the version from `mojo.toml`. Alternatively specify one:

```bash
mopm publish mylibrary 1.2.0
```

MoPM builds `dist/mylibrary-1.2.0.mopm` and submits the archive and metadata for review through GitHub. **No cloning or manual editing of this registry is required.** First-time publishers authenticate with `mopm login`.

The package is available for installation once its submission is reviewed and merged. Existing published versions are immutable.

## Browse packages

- [Central JSON index](index.json)
- [Published .mopm archives](packages)
- [Publishing guide](docs/PUBLISHING.md)

The old `index.tsv` remains temporarily for compatibility with older MoPM clients. New packages are indexed in `index.json`.

## MoPact manifest format (proposal)

For future `.mopm` releases, we are developing a new Mojo-friendly metadata format called [MoPact](docs/MoPact.md), using `package.mopact`. Existing published archives remain unchanged until the parser and installer are verified.
