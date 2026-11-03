# Contributing packages

1. Choose a unique Mojo-module-safe package name using letters, digits and underscores, not beginning with a digit.
2. Submit a pull request adding `packages/NAME/__init__.mojo`, any `.mojo` source files and preferably a README and license.
3. After maintainers review and merge the source, identify its full commit SHA.
4. Register `NAME VERSION DEPENDENCIES` with `scripts/register-package.sh` in a separate commit or pull request, then allow CI to validate it.
5. Previously published `name@version` records cannot be deleted or modified. Publish a new version for any change.

Packages are untrusted third-party code. Registry listing is not a security endorsement. The registry initially hosts sources directly and supports only exact `MAJOR.MINOR.PATCH` versions.
