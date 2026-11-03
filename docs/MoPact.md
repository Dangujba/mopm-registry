# MoPact: proposed Mojo Package Contract (v1)

**File:** `package.mopact` · **Purpose:** human-readable metadata inside future `.mopm` archives.

MoPact is a new line-oriented package manifest format proposed for the MoPM toolchain. It is **not yet accepted by the current published CLI or registry validators**. Previously published `mopm.json` archives remain valid and immutable.

## Example

```text
# A Mojo library
package ~> greeting
version ~> 1.2.0
mojo ~> 1.2.0
source ~> src
about ~> A simple greeting library
license ~> MIT
need ~> json@1.0.0
need ~> http@2.0.0
```

No braces, quotes, indentation rules, commas or TOML sections. Each non-comment line is a `key ~> value` relationship.

**Required (once):** `package`, `version`, `mojo`, `source`.

**Optional (once):** `about`, `license`.

**Repeatable:** `need ~> name@MAJOR.MINOR.PATCH`.

Unknown keys, duplicate fields, invalid identifiers/versions, duplicate dependencies and unsafe paths must be rejected. A package's source is found relative to the manifest.

## Future `.mopm` package format

```text
greeting-1.2.0.mopm
├── package.mopact
└── src/
    ├── __init__.mojo
    └── greet.mojo
```

`mopm publish greeting` should read the version automatically from `package.mopact`, package the library and submit a review request using GitHub authentication. `mopm publish greeting 1.2.0` should also be supported. No registry cloning or runtime Bash scripts should be required.

Registry discovery can still use the machine-readable `index.json`. `package.mopact` is author-facing metadata, not the central package index.

This is a specification proposal, not a released or compiled tool. The sample Mojo parser and regression tests need compiler verification before migration.
