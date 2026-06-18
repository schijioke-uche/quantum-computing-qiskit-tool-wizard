#!/usr/bin/env bash

#---------------------------------------------------------------------------------------------
# @Author: Dr. Jeffrey Chijioke-Uche
# @Project: Quantum Computing Qiskit v2.x Tool Wizard
# @Technology: Quantum Computing, Qiskit
# @File: qiskit-v2x-install-wizard.sh
# @Description: Qiskit v2.x Installer Wizard
# @Version: 1.0.4-production-seeded-pip-verified
# @Date: 2024-01-01
# @License: Apache-2.0
# @Title: Qiskit v2.x Installer Wizard
# @Software Author: Dr. Jeffrey Chijioke-Uche, IBM Computer Science & Quantum Ambassador
#---------------------------------------------------------------------------------------------

set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$SCRIPT_DIR"
export ROOT_DIR
source "$SCRIPT_DIR/lib/wizard.sh"
bnd="---------------------------------------------------------------------------------------------------------------------------------------------"
START_TIME=$(date +%s)

print_step()     { echo -e "\n\033[1;36m🔹 $1\033[0m"; }
print_success()  { echo -e "\033[1;32m✅ $1\033[0m"; }
print_error()    { echo -e "\033[1;31m❌ $1\033[0m"; }
print_warning()  { echo -e "\033[1;33m⚠️  $1\033[0m"; }
print_notice()   { echo -e "\033[1;35m📌 $1\033[0m"; }
print_running()  { echo -e "\033[1;34m🏃 $1\033[0m"; }
print_info()     { echo -e "\033[1;37mℹ️  $1\033[0m"; }

mask_path() {
  local path="$1"
  local masked
  masked=$(echo "$path" | sed -E "s|^$HOME|~|;s|/[^/]+|/***|g")
  echo "$masked"
}




# DO NOT EDIT BELOW THIS LINE:PROPRIETARY LICENSE CHECK: [2] License Check
software_license_check(){
  local lic_check
  lic_check="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/LICENSE"
  if [[ -f "$lic_check" ]]; then
    print_success "Software License: https://github.com/schijioke-uche/quantum-computing-qiskit-tool-wizard/blob/main/LICENSE"
    source "$SCRIPT_DIR/qiskit_lic.sh"

  else
    print_error "License not found in project root."
    print_error "Missing license violates the terms of use for this software - Qiskit Tool Wizard."
    print_error "If the license is not present, please download it from the official repository & add it to the project root."
    print_error "QWizard License Download link: https://github.com/schijioke-uche/quantum-computing-qiskit-tool-wizard/blob/main/LICENSE"
    exit 1
  fi
}

# GLOBAL
VENV_NAME="qiskit-v2x-env"
VENV_PATH="$HOME/$VENV_NAME"
QISKIT_PYTHON_VERSION="${QISKIT_PYTHON_VERSION:-3.12}"
INSTALL_LOG="$SCRIPT_DIR/qiskit-v2x-install.log"

# [1] Install uv per OS
check_uv() {
  if ! command -v uv &>/dev/null; then
    print_step "Installing uv package manager..."

    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
      curl -LsSf https://astral.sh/uv/install.sh | bash
      export PATH="$HOME/.cargo/bin:$HOME/.local/bin:$PATH"

    elif [[ "$OSTYPE" == "darwin"* ]]; then
      curl -LsSf https://astral.sh/uv/install.sh | bash
      export PATH="$HOME/.cargo/bin:$HOME/.local/bin:$PATH"

    elif [[ "$OS" == "Windows_NT" || "$OSTYPE" == "msys"* || "$OSTYPE" == "cygwin" ]]; then
      echo "Please manually install uv from: https://github.com/astral-sh/uv#windows"
      exit 1
    else
      print_error "Unsupported OS for uv installation."
      exit 1
    fi
  fi

  UV_PATH=$(which uv)
  MASKED_UV_PATH="$(dirname "$UV_PATH" | sed 's|.*|/***********|')/$(basename "$UV_PATH")"
  print_success "uv is available: $MASKED_UV_PATH"
}

# [2] Create Python venv
create_venv() {
  print_step "Creating virtual environment: $VENV_NAME"

  if [[ -d "$VENV_PATH" ]]; then
    print_warning "Existing virtual environment found at: ~/$VENV_NAME"
    print_running "Removing existing virtual environment to avoid Python version conflicts."
    rm -rf "$VENV_PATH"
  fi

  : >"$INSTALL_LOG"

  if command -v uv &>/dev/null; then
    print_running "Preparing Python $QISKIT_PYTHON_VERSION for Qiskit v2.x compatibility."
    if uv python install "$QISKIT_PYTHON_VERSION" >>"$INSTALL_LOG" 2>&1 && \
       uv venv --seed --python "$QISKIT_PYTHON_VERSION" "$VENV_PATH" >>"$INSTALL_LOG" 2>&1; then
      :
    elif command -v python3.12 &>/dev/null; then
      print_warning "uv could not prepare Python $QISKIT_PYTHON_VERSION. Falling back to local python3.12."
      python3.12 -m venv "$VENV_PATH"
    else
      print_error "Could not create a Python $QISKIT_PYTHON_VERSION environment."
      print_error "Install Python 3.12 or allow uv to download a managed Python runtime."
      print_error "Diagnostic log: $INSTALL_LOG"
      tail -n 40 "$INSTALL_LOG" || true
      exit 1
    fi
  elif command -v python3.12 &>/dev/null; then
    python3.12 -m venv "$VENV_PATH"
  else
    print_error "Python 3.12 is required for this Qiskit v2.x environment."
    print_error "Run check_uv before create_venv or install Python 3.12."
    exit 1
  fi

  source "$VENV_PATH/bin/activate"

  if ! "$VENV_PATH/bin/python" -m pip --version >>"$INSTALL_LOG" 2>&1; then
    print_error "pip was not seeded into the virtual environment."
    print_error "Diagnostic log: $INSTALL_LOG"
    tail -n 80 "$INSTALL_LOG" || true
    exit 1
  fi

  if ! "$VENV_PATH/bin/python" -m pip install --upgrade pip setuptools wheel >>"$INSTALL_LOG" 2>&1; then
    print_error "Failed to bootstrap pip/setuptools/wheel in $VENV_PATH."
    print_error "Diagnostic log: $INSTALL_LOG"
    tail -n 80 "$INSTALL_LOG" || true
    exit 1
  fi

  # Mask everything under $HOME except final directory
  RESOLVED_HOME=$(realpath "$HOME")
  LAST_DIR=$(basename "$VENV_PATH")
  DISPLAY_PATH="~/***/$LAST_DIR"

  print_success "Qiskit virtual environment created at: $DISPLAY_PATH"
  print_info "Python version: $("$VENV_PATH/bin/python" --version)"
}


# [3] Install Qiskit with venv pip
install_qiskit() {
  print_step "Installing Qiskit Ecosystem ..."
  : >"$INSTALL_LOG"

  local venv_python="$VENV_PATH/bin/python"

  if [[ ! -x "$venv_python" ]]; then
    print_error "Virtual environment Python not found: $venv_python"
    exit 1
  fi

  print_running "Installing Qiskit packages into: $(mask_path "$VENV_PATH")"
  print_info "Installer log: $INSTALL_LOG"

  if "$venv_python" -m pip install --upgrade \
    'qiskit[visualization]' \
    qiskit-connector \
    qiskit-aer \
    qiskit-ibm-runtime \
    qiskit-nature \
    qiskit-nature-pyscf \
    qiskit-serverless \
    qiskit-ibm-catalog \
    matplotlib \
    python-dotenv \
    pyscf >>"$INSTALL_LOG" 2>&1; then

    print_success "Qiskit packages installed."
  else
    print_error "Qiskit package installation failed. See log: $INSTALL_LOG"
    tail -n 100 "$INSTALL_LOG" || true
    exit 1
  fi

  verify_qiskit_installation
  uv pip cache purge >/dev/null 2>&1 || print_info "uv cache purge is not necessary - This is a Lightweight Installation."
}

verify_qiskit_installation() {
  print_step "Verifying Qiskit package installation ..."

  local venv_python="$VENV_PATH/bin/python"
  local missing=0

  for package_name in \
    qiskit \
    qiskit-connector \
    qiskit-aer \
    qiskit-ibm-runtime \
    qiskit-nature \
    qiskit-nature-pyscf \
    qiskit-serverless \
    qiskit-ibm-catalog \
    matplotlib \
    python-dotenv \
    pyscf; do
    if ! "$venv_python" -m pip show "$package_name" >/dev/null 2>&1; then
      print_error "Missing required package: $package_name"
      missing=1
    fi
  done

  if [[ "$missing" -ne 0 ]]; then
    print_error "One or more required packages were not installed into $VENV_PATH."
    print_error "Diagnostic log: $INSTALL_LOG"
    tail -n 100 "$INSTALL_LOG" || true
    exit 1
  fi

  if ! "$venv_python" - <<'PY' >>"$INSTALL_LOG" 2>&1
import qiskit
import qiskit_aer
import qiskit_ibm_runtime
import qiskit_nature
import matplotlib
import dotenv
import pyscf
PY
  then
    print_error "Python import verification failed. Diagnostic log: $INSTALL_LOG"
    tail -n 100 "$INSTALL_LOG" || true
    exit 1
  fi

  print_success "All required Qiskit ecosystem packages verified in $VENV_PATH."
}


# [4] Install Jupyter
install_jupyter() {
  print_step "Installing Jupyter..."
  "$VENV_PATH/bin/python" -m pip install --quiet jupyter ipykernel >>"$INSTALL_LOG" 2>&1
  "$VENV_PATH/bin/python" -m ipykernel install --user --name=qiskit-v2x-env --display-name="Python 3.12 (qiskit-v2x-env)"
  print_success "Jupyter installed."
}

# [5] Display Qiskit Tool Summary
show_summary() {
  echo -e "\n\033[1;36m${bnd}\033[0m"
  print_success "Qiskit Virtual Environment & Tools Setup Complete!"
  print_info "\033[1;36mActivate qiskit virtual environment by running\033[0m: \033[1;35msource ~/qiskit-v2x-env/bin/activate\033[0m"
  echo -e "\033[1;36m🖥️ Basic Qiskit Tools Installed\033[0m"
  "$VENV_PATH/bin/python" -m pip list | grep qiskit
  echo -e "\033[1;36m🖥️ Open Jupyter by running\033[0m: \033[1;35mjupyter notebook\033[0m"
  echo -e "\033[1;36m${bnd}\033[0m"
  deactivate
}


# [6] Main flow
qiskit_development_environment() {
  # echo -e "\n\033[1;34m${QTOOL_WIZARD}\033[0m"
  source "$SCRIPT_DIR/lib/wizard-check.sh"
  check_status_qtool_wizard

  OS=$(uname -s)
  if [[ "$OS" == "Linux" ]]; then
    print_step "Detected OS: 🖥️ Linux Machine - You are installing on this machine."
    software_license_check
    check_uv
    create_venv
    install_qiskit
    install_jupyter
    show_summary

  elif [[ "$OS" == "Darwin" ]]; then
    print_step "Detected OS: 🖥️ macOS Machine - You are installing on this machine."
    software_license_check
    check_uv
    create_venv
    install_qiskit
    install_jupyter
    show_summary

  elif [[ "$OS_TYPE" == "Windows_NT" || "$OS_TYPE" =~ MINGW* || "$OS_TYPE" =~ CYGWIN* || "$OS_TYPE" =~ MSYS* ]]; then
    print_step "Detected: 🪟 Windows OS - You are installing on this machine."
    software_license_check
    WINDOWS_VENV_DIR="$USERPROFILE\\Documents\\Qiskit2x"
    VENV_NAME="qiskit-v2x-env"
    FULL_WINDOWS_PATH="$WINDOWS_VENV_DIR\\$VENV_NAME"

    print_running "Creating directory: $WINDOWS_VENV_DIR"
    mkdir -p "$WINDOWS_VENV_DIR" 2>nul
    cd "$WINDOWS_VENV_DIR" || {
      print_error "Failed to navigate to project directory"
      exit 1
    }

    print_running "Creating Python virtual environment: $FULL_WINDOWS_PATH"
    python -m venv "$FULL_WINDOWS_PATH" || {
      print_error "❌ Failed to create virtual environment at $FULL_WINDOWS_PATH"
      exit 1
    }

    print_success "✅ Qiskit virtual environment created at: $FULL_WINDOWS_PATH"
    check_uv
    print_step "🔹 Installing Qiskit ecosystem via pip..."
    "$FULL_WINDOWS_PATH\\Scripts\\python.exe" -m pip install --upgrade \
      'qiskit[visualization]' \
      qiskit-connector \
      qiskit-aer \
      qiskit-ibm-runtime \
      qiskit-nature \
      qiskit-nature-pyscf \
      qiskit-serverless \
      qiskit-ibm-catalog \
      matplotlib \
      python-dotenv \
      pyscf >nul 2>&1

    print_success "Qiskit and dependencies installed successfully."
    print_step "🧪 Installed Qiskit Packages:"
    "$FULL_WINDOWS_PATH\\Scripts\\python.exe" -m pip list | findstr qiskit
    print_notice "Activate your environment using the instructions below:"
    echo -e "\nIf you are using \033[1;35mCommand Prompt (cmd.exe)\033[0m:"
    echo -e "  \033[1;32m$FULL_WINDOWS_PATH\\Scripts\\activate.bat\033[0m"
    echo -e "\nIf you are using \033[1;35mPowerShell\033[0m:"
    echo -e "  \033[1;32m$FULL_WINDOWS_PATH\\Scripts\\Activate.ps1\033[0m"
    echo -e "\033[1;36m🖥️ Open Jupyter\033[0m: \033[1;35mjupyter notebook\033[0m"

  else
    print_error "Your OS is not supported. Please use Linux, macOS, or Windows."
    exit 1
  fi
}
# 🔁 Execute
qiskit_development_environment
END_TIME=$(date +%s)
ELAPSED_TIME=$((END_TIME - START_TIME))
echo ""
echo -e "\033[1;36m⏱️  Qiskit v2.x Environment setup time: $ELAPSED_TIME seconds.\033[0m"
