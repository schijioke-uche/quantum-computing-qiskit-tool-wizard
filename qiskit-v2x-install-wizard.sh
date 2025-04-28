#!/usr/bin/env bash

#-------------------------------------------
# @Author: Dr. Jeffrey Chijioke-Uche, IBM
# @Sofware: Qiskit v2.x Starter Tool Wizard 
#-------------------------------------------

set -e # 🎨 Helper
print_step() {
    echo -e "\n\033[1;36m🔹 $1\033[0m"
}
print_success() {
    echo -e "\033[1;32m✅ $1\033[0m"
}
print_error() {
    echo -e "\033[1;31m❌ $1\033[0m"
}

# 🐍 Binder
bnd="-------------------------------------------------------"

quantum_terminal() {
  local lic
  lic=$(find ~ -type f -path "*/quantum-qiskit-v2x-startertool-wizard/qiskit_lic.sh" 2>/dev/null | head -n 1)
  source $lic
  echo -e "\033[1;36m🌌 Welcome to the Quantum Terminal Environment Setup Wizard\033[0m"
  echo -e "\033[1;33mPlease select your terminal environment type:\033[0m"
  echo -e "\033[1;32m[0]\033[0m Linux Terminal (default)"
  echo -e "\033[1;32m[1]\033[0m Linux Terminal (zsh)"
  echo -e "\033[1;32m[2]\033[0m macOS Terminal (default)"
  echo -e "\033[1;32m[3]\033[0m macOS Terminal (zsh)"
  echo -e "\033[1;32m[4]\033[0m Windows Terminal (default)"
  echo -e "\033[1;32m[5]\033[0m Windows Terminal (zsh)"

  read -p $'\n\033[1;35mEnter option number [0-5]: \033[0m' terminal

  # 🌱 Create Python virtual environment
  echo -e "\n\033[1;36m📦 Creating Python virtual environment in ~/qiskit-v2x-env...\033[0m"
  python -m venv ~/qiskit-v2x-env || { echo -e "\033[1;31m❌ Failed to create virtual environment.\033[0m"; return 1; }

  echo -e "\033[1;32m✅ Virtual environment created successfully!\033[0m"

  # 💡 Activate environment and install Qiskit
  case $terminal in
    0|1|2|3)
      echo -e "\033[1;36m⚡ Activating environment for Unix-like system...\033[0m"
      source ~/qiskit-v2x-env/bin/activate
      ;;
    4|5)
      echo -e "\033[1;36m⚡ Activating environment for Windows...\033[0m"
      source ~/qiskit-v2x-env/Scripts/activate
      ;;
    *)
      echo -e "\033[1;31m❌ Invalid selection. Exiting.\033[0m"
      return 1
      ;;
  esac

  echo -e "\033[1;36m🌐 Installing Qiskit with visualization support...\033[0m"
  
  if [[ "$terminal" == "1" || "$terminal" == "3" || "$terminal" == "5" ]]; then
    pip install 'qiskit[visualization]'
  else
    pip install qiskit[visualization]
  fi

  echo -e "\n\033[1;32m🎉 Qiskit environment created!"
}


# 🐍 Directory For Virtual Environment
change_dir() {
  cd ~ && print_success "Changed directory successfully to project home.."
  sleep 5
  print_step "Preparing for Qiskit v2.x startertool wizard installation..."
}


# Quantum Account Interactive Setup:
quantum_plans() {
  local file
  file=$(find ~ -type f -path "*/quantum-qiskit-v2x-startertool-wizard/ibm-q/q.py" 2>/dev/null | head -n 1)

  if [[ -n "$file" && -f "$file" ]]; then
    echo -e "\033[1;32m🐍 Preparing Quantum Account Starter Tool module...\033[0m"
    sleep 2
    python "$file"
  else
    echo -e "\033[1;31m❌ 'ibm-q/q.py' starter module not found or inaccessible.\033[0m"
    return 1
  fi
}


# 📦 Install Required Qiskit 1v1.x & its Ecosystem
package_install() {
    print_step "Upgrading pip, setuptools, and wheel..."
    pip install --upgrade pip setuptools wheel
    print_step "Installing Qiskit Tool Ecosystem..."
    pip install          \
        qiskit            \
        qiskit-connector   \
        qiskit-aer          \
        qiskit-ibm-runtime   \
        qiskit-nature         \
        qiskit-nature-pyscf    \
        qiskit-serverless       \
        qiskit-ibm-catalog       \
        python-dotenv             \
        matplotlib                 \
        jupyter                     \
        pyscf                      \
        #qiskit-algorithms  \  IBM no longer support this package.
        #qiskit-optimization \
    echo "" 
    echo -e "\033[1;33m$bnd\033[0m"
    python -m pip freeze
    echo -e "\033[1;33m$bnd\033[0m"  
    echo "" 
    print_success "All Qiskit v2.x packages installed!"
    echo -e "\033[1;36m🌌 QUANTUM PLAN ACCOUNT BACKEND CONNECTION\033[0m"
    print_step "Purging pip cache..."
    pip cache purge || print_warning "Pip cache purge failed."
}

# 🚀 Main..
main() {
    change_dir
    quantum_terminal
    package_install
    print_success "Qiskit environment and fundamental packages setup complete!"
    . ~/qiskit-v2x-env/bin/activate
    print_step "Installed Qiskit Packages:"
    pip list | grep qiskit
    echo -e "🧪 You can now start developing quantum solutions using Qiskit!\033[0m"
    echo -e "🔹 To start your quantum qiskit environment, run any of these:\033[0m"
    echo -e "\n\033[1;36m🧪 You can now start developing quantum solutions using Qiskit!:\033[0m"
    echo -e "🖥️ Linux/macOS: \033[1;32msource ~/qiskit-v2x-env/bin/activate\033[0m"
    echo -e "🖥️ Windows:     \033[1;32msource ~/qiskit-v2x-env/Scripts/activate\033[0m"
    echo -e "\n🚀 Launch Jupyter via: \033[1;35mjupyter notebook\033[0m"
    deactivate
}
main
