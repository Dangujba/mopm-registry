# Running MoPM Registry Validation

The workflow file is [`.github/workflows/registry.yml`](../.github/workflows/registry.yml), which runs directly inside GitHub Actions and does not call any scripts in a `scripts/` directory.

## Why CI is currently failing

GitHub Actions run [#27](https://github.com/Dangujba/mopm-registry/actions/runs/41740604096) failed **before a runner was assigned**, with this annotation:

> The job was not started because your account is locked due to a billing issue.

This is a GitHub account/billing restriction, not a Mojo compiler or registry validation error. No workflow code or branch change can bypass the account lock.

## Fix the billing restriction

Visit https://github.com/settings/billing while signed into the repository owner's GitHub account. Resolve any outstanding balance or payment verification issue and confirm GitHub Actions is enabled for the account.

## Run in GitHub's website

1. Visit https://github.com/Dangujba/mopm-registry/actions/workflows/registry.yml
2. Select **Run workflow**, choose branch `main`, then click **Run workflow**.
3. Click the new run and review **validate**.

This works because `workflow_dispatch:` is now present.

## Run with GitHub CLI

Install [GitHub CLI](https://cli.github.com/) and authenticate if needed:

```sh
gh auth login
gh workflow run registry.yml --repo Dangujba/mopm-registry --ref main
gh run list --repo Dangujba/mopm-registry --workflow registry.yml --limit 5
```

Use the latest run ID from that list:

```sh
gh run watch RUN_ID --repo Dangujba/mopm-registry --exit-status
gh run view RUN_ID --repo Dangujba/mopm-registry --log-failed
```

To rerun historical run #27 after billing is fixed:

```sh
gh run rerun 41740604096 --repo Dangujba/mopm-registry
```

The historical rerun uses the prior workflow revision. Prefer triggering a fresh run of `main` to test the updated workflow.

## Local smoke-check of published archives

Run from the root directory of a clone of this repository:

```sh
python3 - <<'PY'
import hashlib, json, pathlib, zipfile
catalog = json.loads(pathlib.Path("index.json").read_text())
assert catalog["schema"] == 2
checked = 0
for name, package in catalog["packages"].items():
    assert package["latest"] in package["versions"], name
    for version, release in package["versions"].items():
        path = pathlib.Path(release["file"])
        assert path == pathlib.Path("packages") / name / f"{version}.mopm"
        contents = path.read_bytes()
        assert len(contents) == release["size"], path
        assert hashlib.sha256(contents).hexdigest() == release["sha256"], path
        with zipfile.ZipFile(path) as archive:
            assert archive.testzip() is None
            assert "src/__init__.mojo" in archive.namelist()
            assert "mopm.json" in archive.namelist() or "package.mopact" in archive.namelist()
        checked += 1
print(f"PASS: {checked} MoPM archive(s) verified")
PY
```

This is a **smoke-check**, not a substitute for the full workflow's security and immutability validation. Python is used only for this optional local CI inspection, never by MoPM's intended native Mojo package engine.
