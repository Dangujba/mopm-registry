# MoPact v2: Plain-language Mojo library manifests

**Filename:** `package.mopact`  
**Distribution archive:** `name-version.mopm`  
**Status:** Specification and Mojo parser source, pending compiler verification.

## Example

```text
# My Mojo package
library greeter 1.2.0
for mojo 1.2.0
from src
about Simple greetings for Mojo
license MIT

needs json 1.0.0
needs http 2.0.0
```

MoPact uses a small, human-readable, line-based grammar rather than `~>`, braces, commas, quotes, YAML indentation or TOML sections.

| Statement | Meaning |
| --- | --- |
| `library NAME VERSION` | Identity, required once |
| `for mojo VERSION` | Mojo compiler compatibility, required once |
| `from PATH` | Relative source directory, required once |
| `about TEXT` | Free-form description, optional once |
| `license IDENTIFIER` | License identifier, optional once |
| `needs NAME VERSION` | Exact dependency version, repeatable |

Package names must be valid Mojo module identifiers. A version consists of exactly three nonnegative numeric components without leading zeros. The parser rejects duplicate directives, duplicate dependencies, self-dependencies, unknown keywords and path traversal. Only entire lines beginning with `#` after whitespace are comments.

This particular grammar is designed for MoPM, although no guarantee is made that individual tokens or similar language constructs have never appeared elsewhere.

## Planned user commands

```sh
mopm install greeter
mopm uninstall greeter
mopm show greeter
mopm inspect
mopm list
mopm freeze
mopm check
mopm lock
mopm download greeter
mopm wheel .
mopm hash greeter-1.2.0.mopm
mopm search greeter
mopm index versions greeter
mopm cache info
mopm config list
mopm debug
mopm publish greeter
```

`wheel` builds a `.mopm` archive for Mojo; it **does not** build a Python wheel. See [MoPM command contract](MoPM-CLI-Commands.md).

## Publishing

Run `mopm publish greeter` to read `1.2.0` from the manifest. Run `mopm publish greeter 1.2.1` to select an explicit release version. The CLI should assemble the archive, hash it, authenticate and submit it for registry review without a local registry clone.

Inside a new archive:

```text
greeter-1.2.0.mopm
├── package.mopact
└── src/
    ├── __init__.mojo
    └── greet.mojo
```

The centralized `index.json` remains internal registry discovery metadata; users do not edit it. Previously published `mopm.json` archives remain immutable and readable. These changes require a compatible installer and full native compile/test verification before release.
