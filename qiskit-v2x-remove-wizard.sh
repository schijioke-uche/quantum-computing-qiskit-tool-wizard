#!/usr/bin/env bash

set -e

# 🎨 Echo Helpers
print_step() { echo -e "\n\033[1;36m🔸 $1\033[0m"; }
print_success() { echo -e "\033[1;32m✅ $1\033[0m"; }
print_warning() { echo -e "\033[1;33m⚠️ $1\033[0m"; }
print_error() { echo -e "\033[1;31m❌ $1\033[0m"; }

# 🐍 Deactivate virtual environment if active and remove its folder
delete_virtual_env() {
    print_step "Deactivating any active virtual environment..."
    local LICENSE_FILE="$ROOT_DIR/LICENSE"
    local STORE_DIR="$ROOT_DIR/license-acceptance"
    
    if [[ -n "$VIRTUAL_ENV" ]]; then
        echo -e "\033[1;33m⚠️ Detected active virtual environment at: $VIRTUAL_ENV\033[0m"
        if type deactivate &>/dev/null; then
            deactivate
            print_success "Virtual environment deactivated."
        else
            print_warning "The command [deactivate] not available in current shell context - Virtual environment probably already deactivated."
        fi
    else
        print_warning "No active virtual environment detected."
    fi

    print_step "Removing '~/qiskit-v2x-env' directory (if it exists)..."
    rm -rf ~/qiskit-v2x-env && print_success "Removed ~/qiskit-v2x-env." || print_warning "Directory not found or already removed."
}


# 🐍 Directory For Virtual Environment
change_dir() {
  cd ~ && print_success "Changed directory successfully to project home.."
  sleep 5
  print_step "Preparing for Qiskit v2.x startertool wizard uninstall..."
}

# Wiper
wiper(){
    print_step "Final Cleaning of '~/qiskit-v2x-env' directory..."
    rm -rf ~/qiskit-v2x-env 
    print_success "Cleaning of 'qiskit-v2x-env' virtual environment completed!"
}


# 🚀 Execute
#-------------
change_dir
delete_virtual_env
wiper
