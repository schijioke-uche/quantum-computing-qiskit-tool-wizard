#!/usr/bin/env bash

set -e

# 🎨 Echo Helpers
print_step() { echo -e "\n\033[1;36m🔸 $1\033[0m"; }
print_success() { echo -e "\033[1;32m✅ $1\033[0m"; }
print_warning() { echo -e "\033[1;33m⚠️ $1\033[0m"; }
print_error() { echo -e "\033[1;31m❌ $1\033[0m"; }

# 🐍 Deactivate and Remove Python Virtual Environment
delete_virtual_env() {
    print_step "Deactivating any active virtual environment..."
    if [[ "$VIRTUAL_ENV" != "" ]]; then
        deactivate || print_warning "Not inside an active virtual environment."
    else
        print_warning "No active virtual environment to deactivate."
    fi
}

# 🐍 Directory For Virtual Environment
change_dir() {
  cd ~
}

# 🐍 Deactivate and Remove Python Virtual Environment...
remove_packages_in_env() {
    
    print_step "Uninstalling Qiskit packages..."
    pip uninstall -y \
        qiskit \
        qiskit-aer \
        qiskit-algorithms \
        qiskit-ibm-runtime \
        qiskit-nature \
        qiskit-nature-pyscf \
        qiskit-serverless \
        matplotlib \
        qiskit-ibm-catalog \
        python-dotenv  \
        qiskit-ibm-provider \
        --root-user-action=ignore || print_warning "Some Qiskit packages may not be installed."

    print_step "Purging pip cache..."
    pip cache purge || print_warning "Pip cache purge failed or unsupported."

    print_step "Removing '~/qiskit-env' directory..."
    rm -rf ~/qiskit-env && print_success "'qiskit-env' installation removed."

    sleep 1
    print_step "📋 Remaining Qiskit-related packages:"
    pip list | grep qiskit || echo -e "\033[1;35m🚫 No Qiskit packages found.\033[0m"
}

# 🚀 Execute
change_dir
remove_packages_in_env
delete_virtual_env
