# MoPM Central Package Registry

The official centralized registry for Mojo libraries. Packages are distributed as versioned **`.mopm`** archives and indexed by [`index.json`](index.json). Package publishers do not need to clone this repository.

## One-command package management

```bash
mopm install greeter
mopm install greeter@1.0.1
mopm uninstall greeter
mopm publish mylibrary
```

MoPM is being developed as a native Mojo package manager. The commands below define its **planned complete CLI**, including subcommands. Some commands are not implemented in the current preview; see [Command Specification](docs/MoPM-CLI-Commands.md).

## All MoPM commands and subcommands

### Installing and managing libraries

| Command | Purpose |
| --- | --- |
| `mopm install NAME` | Install the latest compatible package and its dependencies |
| `mopm install NAME@VERSION` | Install an exact version |
| `mopm install --locked` | Restore dependencies from `mopm.lock` |
| `mopm install --offline` | Install from local cache without network access |
| `mopm install --force-reinstall NAME` | Reinstall a package |
| `mopm uninstall NAME` | Uninstall a library |
| `mopm uninstall NAME --yes` | Uninstall without a confirmation prompt |
| `mopm update` | Update all direct dependencies |
| `mopm update NAME` | Update one dependency |
| `mopm inspect` | Show dependency graph and installation metadata |
| `mopm inspect --json` | Machine-readable dependency graph |
| `mopm list` | List installed libraries |
| `mopm list --outdated` | Show libraries with available updates |
| `mopm show NAME` | Show a library's details |
| `mopm freeze` | Output installed libraries with exact versions |
| `mopm check` | Verify versions, hashes, installed files and dependency compatibility |

### Resolving and distributing packages

| Command | Purpose |
| --- | --- |
| `mopm lock` | Resolve dependencies and create `mopm.lock` |
| `mopm lock --check` | Verify the lockfile without modifying it |
| `mopm lock --update` | Refresh dependency resolution |
| `mopm download NAME` | Download a `.mopm` package without installing |
| `mopm download NAME@VERSION` | Download an exact version |
| `mopm download NAME --dest DIR` | Save an archive in a chosen directory |
| `mopm wheel .` | Build a `.mopm` distribution archive (not a Python wheel) |
| `mopm pack .` | Alias for `mopm wheel .` |
| `mopm hash FILE.mopm` | Calculate SHA-256 of an archive |
| `mopm hash FILE.mopm --verify HASH` | Compare the file against an expected digest |

### Searching and querying the central index

| Command | Purpose |
| --- | --- |
| `mopm search QUERY` | Search published libraries |
| `mopm index versions NAME` | Show all released versions |
| `mopm index info NAME` | Show package metadata and publisher |
| `mopm index list` | List available libraries |
| `mopm index refresh` | Refresh the local registry metadata cache |

### Managing the package cache

| Command | Purpose |
| --- | --- |
| `mopm cache dir` | Show the cache directory |
| `mopm cache info` | Show cache size and counts |
| `mopm cache list` | List cached packages |
| `mopm cache remove NAME` | Remove cached versions of a library |
| `mopm cache purge` | Remove all cached package archives |

### Configuring MoPM

| Command | Purpose |
| --- | --- |
| `mopm config list` | Show effective non-secret settings |
| `mopm config get KEY` | Read a setting |
| `mopm config set KEY VALUE` | Save a setting |
| `mopm config unset KEY` | Delete a setting override |
| `mopm config path` | Show the configuration file location |
| `mopm config debug` | Display where settings came from (without secrets) |

### Debugging and diagnostics

| Command | Purpose |
| --- | --- |
| `mopm debug` | Display environment and diagnostic summary |
| `mopm debug --verbose` | Display detailed diagnostics |
| `mopm debug environment` | Inspect OS, architecture and Mojo toolchain |
| `mopm debug registry` | Check registry connectivity and metadata |
| `mopm debug cache` | Diagnose the local cache |
| `mopm debug network` | Check HTTPS and certificate configuration |

### Publishing and project tools

| Command | Purpose |
| --- | --- |
| `mopm init NAME` | Create a Mojo library project and `package.mopact` |
| `mopm login` | Authenticate a publisher with GitHub |
| `mopm logout` | Sign out of publisher authentication |
| `mopm publish NAME` | Build and submit the version in `package.mopact` |
| `mopm publish NAME VERSION` | Publish a specified version |
| `mopm version` | Show MoPM version |
| `mopm help` | Show all main commands |
| `mopm help COMMAND` | Show command-specific syntax and subcommands |
| `mopm COMMAND --help` | Show help directly for a command |

## MoPact: the library manifest

A Mojo library uses **`package.mopact`**:

```text
library greeter 1.2.0
for mojo 1.2.0
from src
about Simple greetings for Mojo
license MIT
needs json 1.0.0
```

See the [MoPact syntax specification](docs/MoPact.md) and [publishing guide](docs/PUBLISHING.md).

## Central registry layout

- [`index.json`](index.json): machine-readable package catalogue used by MoPM
- [`packages/`](packages): downloadable `.mopm` archives
- [`docs/MoPM-CLI-Commands.md`](docs/MoPM-CLI-Commands.md): command specifications and required behavior
- [`docs/PUBLISHING.md`](docs/PUBLISHING.md): publishing instructions

The previous `index.tsv` and `mopm.json` formats are retained for compatibility with published packages. Existing published package versions are immutable.
