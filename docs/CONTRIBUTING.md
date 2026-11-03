# Contributing a Mojo library

Package authors do not need to clone or edit the registry repository.

From the library directory, run:

```bash
mopm publish mylibrary
```

The version comes from `[package].version` in `mojo.toml`. To override it for the submitted release, run `mopm publish mylibrary 1.2.0`.

The CLI packages the library into a `.mopm` archive and submits a pull request automatically. First-time publishers run `mopm login` once to authenticate with GitHub.

Requirements: a unique Mojo package name, an exact semantic version, `__init__.mojo`, valid Mojo source files and exact versions for each declared package dependency. Published versions are immutable. Maintainers review each submission and the automated archive/index checks before approval.
