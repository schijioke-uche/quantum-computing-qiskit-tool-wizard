#!/usr/bin/env bash

#--------------------------------------------------------
# Qiskit v2.x Installer Wizard
# Author: Dr. Jeffrey Chijioke-Uche, IBM Quantum Ambassador
#--------------------------------------------------------

set -e
bnd="----------------------------------------------------------------------------------------------------------------------------"
START_TIME=$(date +%s)

print_step()     { echo -e "\n\033[1;36m🔹 $1\033[0m"; }
print_success()  { echo -e "\033[1;32m✅ $1\033[0m"; }
print_error()    { echo -e "\033[1;31m❌ $1\033[0m"; }
print_warning()  { echo -e "\033[1;33m⚠️  $1\033[0m"; }
print_notice()   { echo -e "\033[1;35m📌 $1\033[0m"; }
print_running()  { echo -e "\033[1;34m🏃 $1\033[0m"; }
print_info()     { echo -e "\033[1;37mℹ️  $1\033[0m"; }


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

  print_success "uv is available: $(which uv)"
}

# [2] Create Python venv
create_venv() {
  print_step "Creating virtual environment: $VENV_NAME"
  python3 -m venv "$VENV_PATH"
  source "$VENV_PATH/bin/activate"
  print_success "Virtual environment created at $VENV_PATH"
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
  uv pip cache purge >/dev/null 2>&1 || print_info "uv cache purge failed."
}

# [4] Install Jupyter
install_jupyter() {
  print_step "Installing Jupyter..."
  uv pip install --quiet jupyter >/dev/null 2>&1
  print_success "Jupyter installed."
}

# [5] Display Summary
show_summary() {
  echo -e "\n\033[1;36m${bnd}\033[0m"
  print_success "Qiskit setup complete!"
  echo "Activate it using: source ~/qiskit-v2x-env/bin/activate"
  echo -e "\n\033[1;36mInstalled Packages:\033[0m"
  pip list | grep qiskit
  echo -e "\nLaunch Jupyter using: \033[1;35mjupyter notebook\033[0m"
  echo -e "\033[1;36m${bnd}\033[0m"
  deactivate
}

# [6] Main flow
qiskit_development_environment() {
  echo -e "\n\033[1;34m🔹 Starting Qiskit Environment Setup...\033[0m"
  OS=$(uname -s)

  if [[ "$OS" == "Linux" ]]; then
    print_step "Detected OS: Linux"
    create_venv
    check_uv
    install_qiskit
    install_jupyter
    show_summary

  elif [[ "$OS" == "Darwin" ]]; then
    print_step "Detected OS: macOS"
    create_venv
    check_uv
    install_qiskit
    install_jupyter
    show_summary

  elif [[ "$OS_TYPE" == "Windows_NT" || "$OS_TYPE" =~ MINGW* || "$OS_TYPE" =~ CYGWIN* || "$OS_TYPE" =~ MSYS* ]]; then
    print_step "🪟 Windows OS Detected"
    
    WINDOWS_VENV_DIR="$USERPROFILE\\Documents\\QiskitProject"
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

    print_success "✅ Qiskit and dependencies installed successfully."
    print_step "🧪 Installed Qiskit Packages:"
    "$FULL_WINDOWS_PATH\\Scripts\\python.exe" -m pip list | findstr qiskit

    print_notice "Activate your environment using the instructions below:"
    echo -e "\nIf you are using \033[1;35mCommand Prompt (cmd.exe)\033[0m:"
    echo -e "  \033[1;32m$FULL_WINDOWS_PATH\\Scripts\\activate.bat\033[0m"
    echo -e "\nIf you are using \033[1;35mPowerShell\033[0m:"
    echo -e "  \033[1;32m$FULL_WINDOWS_PATH\\Scripts\\Activate.ps1\033[0m"
    echo -e "\n🖥️ Jupyter Launch: \033[1;35mjupyter notebook\033[0m"

  else
    print_error "Your OS is not supported."
    exit 1
  fi
}
# 🔁 Execute
qiskit_development_environment
END_TIME=$(date +%s)
ELAPSED_TIME=$((END_TIME - START_TIME))
echo ""
echo -e "\033[1;36m⏱️  Qiskit v2.x Environment setup time: $ELAPSED_TIME seconds.\033[0m"

