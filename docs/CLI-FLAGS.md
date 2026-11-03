# MoPM CLI flag reference (planned specification)

**Status:** interface design for a future native Mojo CLI. This file is **not** evidence that any flag currently works. Each flag must have parser tests, command integration tests, help text and platform verification before being declared supported.

## Flag conventions

- Long flags use `--kebab-case`; common short flags use one letter. Both `--flag=value` and `--flag value` work for valued flags, except where stated otherwise.
- Options may appear before or after positional arguments. `--` ends option parsing, so package names beginning with `-` are not misread as flags.
- Unknown flags, missing values, invalid types, duplicate conflicting flags and unsupported command combinations must fail clearly with exit code **2**.
- Global flags: `-h, --help`, `-V, --version`, `-v, --verbose`, `-q, --quiet`, `--no-color`, `--registry URL` and `--cache-dir PATH`. `--help` exits 0 without executing anything.
- `--verbose` and `--quiet` are mutually exclusive. Information printed as `--json` must be valid machine-readable JSON on stdout, with diagnostics on stderr.
- `--offline` is a strict no-network mode, including metadata refreshes, and must reject missing or unverified cache entries. `--dry-run` performs no installation, removal, lockfile overwrite, registry write or publication.
- `--yes` skips confirmation only; it never bypasses integrity checks or authorization. `--no-deps` skips dependency installation, **but** `mopm check` must still report unmet requirements.
- `--registry URL` and `--cache-dir PATH` override configured values only for that invocation. Prefer HTTPS registries; reject insecure HTTP except an explicitly configured local development endpoint.
- All package archives, including cached archives, require SHA-256 verification against trusted registry/lock metadata. Do not expose auth tokens in logs, JSON diagnostics or config listing.

## Commands and options

### install — `mopm install NAME[@VERSION] [OPTIONS]`

| Flag | Meaning |
| --- | --- |
| `-U, --upgrade` | Resolve and replace with latest compatible release, including existing package |
| `--locked` | Install exact versions and checksums from `mopm.lock`; fail on mismatch or missing entries |
| `--offline` | Install only from verified cached archives and metadata |
| `--force-reinstall` | Reinstall even if the selected version is already installed |
| `--dry-run` | Preview resolution and filesystem changes without modifying state |
| `--no-deps` | Install only the requested package; report unmet requirements in later checks |

**Rules:** `--upgrade` and `--locked` cannot be combined. `NAME@VERSION --locked` is valid only when the pin matches the lockfile. Installs are transactional and never overwrite user source files.

### uninstall — `mopm uninstall NAME [OPTIONS]`

| Flag | Meaning |
| --- | --- |
| `-y, --yes` | Skip the confirmation dialog |
| `--dry-run` | Show removals without modifying state |

Remove only MoPM-managed packages and safe orphaned transitive dependencies. Preserve dependencies still needed by other packages.

### inspect — `mopm inspect [OPTIONS]`

| Flag | Meaning |
| --- | --- |
| `--json` | Print installed dependency graph and metadata as JSON |
| `--tree` | Render a readable dependency tree |

`--json` and `--tree` cannot be combined.

### list — `mopm list [OPTIONS]`

| Flag | Meaning |
| --- | --- |
| `--outdated` | Show packages whose compatible registry releases are newer |
| `--json` | Machine-readable installed package list |

`--outdated --offline` is not specified in v1; users should inspect cached versions through `mopm cache list`.

### show — `mopm show NAME [--json]`

`--json` emits the installed package record. Human output includes name, version, source, dependencies, checksum and installed path. Missing packages fail nonzero.

### freeze — `mopm freeze [-o FILE]`

`-o, --output FILE` writes the exact installed versions in deterministic `name@version` order. Without `-o`, print them to stdout. This is **not** a security-equivalent substitute for `mopm.lock` because it omits archive digests.

### check — `mopm check [--json]`

`--json` emits categorized findings, including unresolved dependencies, manifest incompatibility, lockfile mismatches and checksum failures. Nonzero exit on an inconsistent environment.

### lock — `mopm lock [--check | --update] [--offline]`

| Flag | Meaning |
| --- | --- |
| `--check` | Verify the existing deterministic lockfile; never rewrite |
| `--update` | Resolve all package constraints again, then atomically replace the lockfile |
| `--offline` | Resolve only from trusted local index/cache data |

`--check` and `--update` cannot be combined. Reproducible lockfiles pin full versions, source URLs and SHA-256 hashes.

### download — `mopm download NAME[@VERSION] [-d DIR] [--offline] [--with-deps]`

| Flag | Meaning |
| --- | --- |
| `-d, --dest DIR` | Destination folder, default `.` |
| `--offline` | Copy only verified local cache archives |
| `--with-deps` | Also download the resolved transitive dependency archives |

Never extract or install files with `download`.

### wheel / pack — `mopm wheel . [-o DIR] [--check-only]`

| Flag | Meaning |
| --- | --- |
| `-o, --out-dir DIR` | Destination of generated `.mopm` archive, default `dist/` |
| `--check-only` | Parse and validate `package.mopact` and file layout without emitting an archive |

`pack` is a synonym. This builds **MoPM** packages, **not Python wheels**. The published package manifest must be included in the archive.

### hash — `mopm hash FILE.mopm [--verify SHA256]`

`--verify SHA256` checks a lowercase or uppercase 64-digit hexadecimal SHA-256. Without it, print the computed SHA-256 digest. A mismatch fails with integrity exit code 5.

### search — `mopm search QUERY [--limit N] [--json]`

`--limit N` sets the maximum results (positive integer, 1–100); default 20. `--json` emits structured results from MoPM's own registry, rather than the deprecated pip/PyPI search API.

### index — `mopm index {list | info NAME | versions NAME | refresh}`

- `mopm index list --json`: enumerate package records.
- `mopm index info NAME --json`: show one registry package.
- `mopm index versions NAME --json`: list releases and compatibility.
- `mopm index refresh`: refresh local registry metadata. No `--json` required.

### cache — `mopm cache {dir | info | list | remove NAME | purge}`

- `mopm cache info --json` and `mopm cache list --json`: machine-readable results.
- `mopm cache purge -y` / `--yes`: skip confirmation; never remove installed libraries.
- `mopm cache remove NAME`: clear archives for that name; prompt before deletion.

### config — `mopm config {list | get KEY | set KEY VALUE | unset KEY | path | debug}`

- `--scope user|project`: accepted on `get`, `set`, `unset`, `path` to select configuration scope (user by default for writes).
- `mopm config list --json`: emit effective non-secret values.
- `mopm config debug`: report source and precedence of settings without exposing credentials.
- Authentication secrets must be stored separately in an OS-appropriate credential store, not in manifest files.

### debug — `mopm debug [environment|registry|cache|network] [--verbose] [--json]`

- `-v, --verbose`: provide detailed diagnostics without leaking tokens.
- `--json`: emit machine-readable diagnostic results.
- Debug commands must report failures accurately, not falsely claim connectivity or compatibility.

### publish — `mopm publish NAME [VERSION] [--dry-run]`

`--dry-run` fully validates the package manifest, contents, name ownership and local archive, but **does not authenticate, upload or create a pull request**. The standard command needs GitHub authentication and submits a reviewed immutable release without manually cloning the registry.

### init — `mopm init NAME [--dir PATH]`

`--dir PATH` selects a new project destination. Abort if it would overwrite existing files. New projects contain `package.mopact` and a Mojo source skeleton.

### update — `mopm update [NAME] [--dry-run] [--offline]`

- `--dry-run`: show possible version changes with no writes.
- `--offline`: consider only verified cached releases.
- Resolutions must honor constraints and atomically update `mopm.lock`.

### login, logout, help and version

- `mopm login --device`: initiate an interactive GitHub device authorization flow (no shell tools required).
- `mopm logout`: revoke/discard local authentication where possible.
- `mopm help [COMMAND]`, `mopm COMMAND --help`: show complete usage including flags and examples.
- `mopm version`, `mopm --version`, `mopm -V`: show version.

## Test gates before release

For **every** documented flag, verify: both spellings of aliases, parsing regardless of position, `--help`, missing and extra arguments, mutually exclusive options, bad paths, network failure, read-only folders, lockfile integrity, safe extraction, idempotency, correct exit status and Windows/WSL behavior.

A flag is not considered implemented until the native Mojo CLI enforces its behavior end to end. The [README](../README.md) is a quick reference; [command contracts](MoPM-CLI-Commands.md) define required operations.
