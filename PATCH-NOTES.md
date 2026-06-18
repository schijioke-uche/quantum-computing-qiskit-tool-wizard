# Patch Notes - Qiskit v2.x Installer Wizard

## Version
1.0.4-production-seeded-pip-verified

## Root Cause
The previous fixed build created the Python 3.12 virtual environment with `uv venv`, but did not seed `pip` into the environment. The later install step used:

```bash
$VENV_PATH/bin/python -m pip install ...
```

That failed with:

```text
$HOME/qiskit-v2x-env/bin/python: No module named pip
```

## Production Fix
The installer now creates the virtual environment with:

```bash
uv venv --seed --python "$QISKIT_PYTHON_VERSION" "$VENV_PATH"
```

This ensures `pip`, `setuptools`, and `wheel` are present in the environment before package installation begins.

The script also now explicitly verifies:

```bash
$VENV_PATH/bin/python -m pip --version
```

before installing the Qiskit ecosystem.

## Preserved Behavior
- Original banner/wizard flow preserved.
- Original license acceptance flow preserved.
- Environment path remains `~/qiskit-v2x-env`.
- Qiskit-compatible Python remains pinned to 3.12 by default.
- Installation logs are written to `qiskit-v2x-install.log`.
