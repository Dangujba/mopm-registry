# Central registry setup

The official repository is https://github.com/Dangujba/mopm-registry and its default branch is `main`.

To work locally:

```bash
git clone https://github.com/Dangujba/mopm-registry.git
cd mopm-registry
bash scripts/test-registry.sh
```

To publish a source package, commit and push its `packages/NAME/` directory first. Then, from a clean working tree, run:

```bash
bash scripts/register-package.sh NAME 1.0.0 -
git add index.tsv
git commit -m 'Register NAME 1.0.0'
git push
```

The registration helper pins the source commit that existed *before* the index change. For production, protect the `main` branch using repository rules and require pull-request review plus the `Registry validation` check once the workflow is active.
