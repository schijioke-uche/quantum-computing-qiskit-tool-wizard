#!/usr/bin/env bash

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
  cd ~
}

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


# 📦 Install Required Qiskit Packages
package_install() {
    print_step "Upgrading pip, setuptools, and wheel..."
    pip install --upgrade pip setuptools wheel
    print_step "Installing Qiskit packages..."
    pip install         \
        qiskit           \
        qiskit-aer        \
        qiskit-algorithms  \
        qiskit-ibm-runtime  \
        qiskit-nature        \
        qiskit-nature-pyscf   \
        qiskit-serverless      \
        qiskit-ibm-catalog      \
        python-dotenv             \
        clean-dotenv               \
        matplotlib                  \
        jupyter                      \
        pyscf    
    print_success "All Qiskit packages installed!"
    echo -e "\033[1;36m🌌 QUANTUM PLAN ACCOUNT BACKEND CONNECTION\033[0m"
    quantum_plans
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
    echo -e "🧪 To start your quantum qiskit environment, run any of these:\033[0m"
    echo -e "🖥️ For Linux: source ~/qiskit-v2x-env/bin/activate\033[0m"
    echo -e "🖥️ For MacOS: source ~/qiskit-v2x-env/bin/activate\033[0m"
    echo -e "🖥️ For Windows: source ~/qiskit-v2x-env/Scripts/activate\033[0m"
    echo -e "🧪 To open your notebook: jupyter notebook <path/to/notebook.ipynb>\033[0m"
}
main
