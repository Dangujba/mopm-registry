# MoPM command contract — planned public CLI

This specification defines what all commands **must do**. It does not claim the current Mojo CLI already implements them. Functional source, compilation, package resolution and release testing remain separate requirements.

## Package management

| Command | Required behavior |
| --- | --- |
| `mopm install NAME[@VERSION]` | Install latest compatible or specified `.mopm` package and transitive dependencies, update lockfile. One command; no mandatory `init`. Support `--locked` and `--offline`. |
| `mopm uninstall NAME` | Remove package and dependencies no longer used, without deleting user source. |
| `mopm inspect [--json]` | Report installed package graph, metadata and resolved versions; optional machine-readable JSON output. |
| `mopm list [--outdated]` | List currently installed libraries and optionally compare registry versions. |
| `mopm show NAME` | Describe one library: version, author, license, dependencies, artifact hash and installation path. |
| `mopm freeze` | Print exact installed versions in repeatable `name@version` form. |
| `mopm check` | Verify installed package integrity, dependency consistency, lockfile state and Mojo/compiler compatibility. |

## Dependency resolution and distribution files

| Command | Required behavior |
| --- | --- |
| `mopm lock` | Resolve dependencies and write deterministic `mopm.lock` with pinned versions and archive hashes. |
| `mopm download NAME[@VERSION]` | Download and verify package archive without installing; `--dest` selects folder. |
| `mopm wheel .` | MoPM counterpart of pip's build command: produce a `.mopm` archive, **not a Python `.whl`**. `mopm pack` is an alias. |
| `mopm hash FILE.mopm` | Compute SHA-256 and optionally verify it against the lockfile/registry. |

## Central index

| Command | Required behavior |
| --- | --- |
| `mopm search QUERY` | Search names and package descriptions in MoPM's own centralized registry. |
| `mopm index versions NAME` | Show registry versions, latest and compatibility; `mopm index info NAME` describes registry record. |

## Managing MoPM

| Command | Required behavior |
| --- | --- |
| `mopm cache info`, `list`, `purge` | Inspect cached package artifacts and safely delete unused cache entries. |
| `mopm config list`, `get KEY`, `set KEY VALUE` | Display or change registry URL, cache path and output preferences without exposing credentials. |
| `mopm debug [--verbose]` | Diagnose OS/architecture, Mojo compiler, registry access, cache, TLS and dependencies without leaking tokens. |

## Publishing and project development

| Command | Required behavior |
| --- | --- |
| `mopm init NAME` | Create a `package.mopact` project without overwriting existing files. |
| `mopm publish NAME [VERSION]` | Read library manifest, package source, compute digest, authenticate publisher, and submit for review to GitHub registry **without manual clone**. Reject overwrite of existing version. |
| `mopm login`, `mopm logout` | Authenticate publisher with secure GitHub credential flow; no credentials stored in manifests. |
| `mopm update [NAME]` | Move to latest compatible version transactionally and regenerate lockfile. |
| `mopm version`, `mopm help` | Version and documentation. |

## Required behavior across commands

- Installs must be transactional, detect dependency conflicts, reject unsafe archive paths, symlinks and corrupt files, and verify HTTPS + SHA-256 digests.
- Publisher identity must bind package name ownership; all published versions are immutable and subject to registry review.
- Print actionable errors instead of silently succeeding or pretending an unsupported command is available.
- Exit codes: 0 success, 2 CLI usage, 3 resolution, 4 network/registry, 5 security/integrity, 6 filesystem.
- No Python or Bash scripts should be required to run the production package engine. Native libraries through Mojo FFI are permitted when necessary.
- Windows `mopm.exe` must not be misrepresented as native Mojo until Mojo supports and the project has tested native Windows compilation.
