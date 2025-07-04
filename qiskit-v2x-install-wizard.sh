#!/usr/bin/env bash

#---------------------------------------------------------------------------------------------
# @Project: Quantum Computing Qiskit v2.x Tool Wizard
# @Technology: Quantum Computing, Qiskit
# @File: qiskit-v2x-install-wizard.sh
# @Description: Qiskit v2.x Installer Wizard
# @Version: 1.0.0
# @Date: 2024-01-01
# @License: Apache-2.0
# @Title: Qiskit v2.x Installer Wizard
# @Software Author: Dr. Jeffrey Chijioke-Uche, IBM Computer Science & Quantum Ambassador
#---------------------------------------------------------------------------------------------

set -e
  source ./lib/wizard.sh
bnd="----------------------------------------------------------------------------------------------------------------------------"
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
  local masked=$(echo "$path" | sed -E "s|^$HOME|~|;s|/[^/]+|/***|g")
  echo "$masked"
}


# DO NOT EDIT BELOW THIS LINE:PROPRIETARY LICENSE CHECK: [2] License Check
software_license_check(){
  local lic_check
  lic_check="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/LICENSE"
  if [[ -f "$lic_check" ]]; then
    print_success "Software License: https://github.com/schijioke-uche/quantum-computing-qiskit-tool-wizard/blob/main/LICENSE"
    source ./qiskit_lic.sh

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

# [1] Install uv per OS
check_uv() {
  if ! command -v uv &>/dev/null; then
    print_step "Installing uv package manager..."

    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
      curl -LsSf https://astral.sh/uv/install.sh | bash
      export PATH="$HOME/.cargo/bin:$PATH"

    elif [[ "$OSTYPE" == "darwin"* ]]; then
      curl -LsSf https://astral.sh/uv/install.sh | bash
      export PATH="$HOME/.cargo/bin:$PATH"

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
  python3 -m venv "$VENV_PATH"
  source "$VENV_PATH/bin/activate"

  # Mask everything under $HOME except final directory
  RESOLVED_HOME=$(realpath "$HOME")
  LAST_DIR=$(basename "$VENV_PATH")
  DISPLAY_PATH="~/***/$LAST_DIR"

  print_success "Qiskit virtual environment created at: $DISPLAY_PATH"
}


# [3] Install Qiskit with uv
install_qiskit() {
  print_step "Installing Qiskit Ecosystem ..."
  uv pip install --upgrade --quiet \
    qiskit[visualization] \
    qiskit-connector \
    qiskit-aer \
    qiskit-ibm-runtime \
    qiskit-nature \
    qiskit-nature-pyscf \
    qiskit-serverless \
    qiskit-ibm-catalog \
    matplotlib \
    python-dotenv \
    pyscf >/dev/null 2>&1

  print_success "Qiskit packages installed."
  uv pip cache purge >/dev/null 2>&1 || print_info "uv cache purge is not necessary - This is a Lightweight Installation."
}

# [4] Install Jupyter
install_jupyter() {
  print_step "Installing Jupyter..."
  uv pip install --quiet jupyter >/dev/null 2>&1
  print_success "Jupyter installed."
}

# [5] Display Qiskit Tool Summary
show_summary() {
  echo -e "\n\033[1;36m${bnd}\033[0m"
  print_success "Qiskit Virtual Environment & Tools Setup Complete!"
  print_info "\033[1;36mActivate qiskit virtual environment by running\033[0m: \033[1;35msource ~/qiskit-v2x-env/bin/activate\033[0m"
  echo -e "\033[1;36m🖥️ Basic Qiskit Tools Installed\033[0m"
  pip list | grep qiskit
  echo -e "\033[1;36m🖥️ Open Jupyter by running\033[0m: \033[1;35mjupyter notebook\033[0m"
  echo -e "\033[1;36m${bnd}\033[0m"
  deactivate
}


# [6] Main flow
qiskit_development_environment() {
  echo -e "\n\033[1;34m${QTOOL_WIZARD}\033[0m"
  source ./lib/wizard-check.sh
  check_status_qtool_wizard

  OS=$(uname -s)
  if [[ "$OS" == "Linux" ]]; then
    print_step "Detected OS: 🖥️ Linux Machine - You are installing on this machine."
    software_license_check
    create_venv
    check_uv
    install_qiskit
    install_jupyter
    show_summary

  elif [[ "$OS" == "Darwin" ]]; then
    print_step "Detected OS: 🖥️ macOS Machine - You are installing on this machine."
    software_license_check
    create_venv
    check_uv
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
    print_step "🔹 Installing Qiskit ecosystem via uv..."
    uv pip install --quiet --upgrade \
      qiskit[visualization] \
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

