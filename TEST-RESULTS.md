# Test Results - Qiskit v2.x Installer Wizard

## Static validation

```text
bash -n qiskit-v2x-install-wizard.sh: PASS
```

## Reproduced user error

The previous build failed because the target Python 3.12 environment did not contain `pip`:

```text
$HOME/qiskit-v2x-env/bin/python: No module named pip
```

## Fix validation

The installer now creates the environment with:

```bash
uv venv --seed --python "$QISKIT_PYTHON_VERSION" "$VENV_PATH"
```

The script then verifies:

```bash
$VENV_PATH/bin/python -m pip --version
```

before attempting any Qiskit package installation.

## Package install target

All Qiskit package installation is targeted to:

```bash
$VENV_PATH/bin/python -m pip install --upgrade ...
```

This prevents installation into the wrong Python environment.

## Verification gate

The script does not print final success unless these distributions are present inside `~/qiskit-v2x-env`:

```text
qiskit
qiskit-connector
qiskit-aer
qiskit-ibm-runtime
qiskit-nature
qiskit-nature-pyscf
qiskit-serverless
qiskit-ibm-catalog
matplotlib
python-dotenv
pyscf
```
