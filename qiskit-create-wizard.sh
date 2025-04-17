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
  source qiskit_lic.sh
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
  echo -e "\n\033[1;36m📦 Creating Python virtual environment in ~/qiskit-env...\033[0m"
  python -m venv ~/qiskit-env || { echo -e "\033[1;31m❌ Failed to create virtual environment.\033[0m"; return 1; }

  echo -e "\033[1;32m✅ Virtual environment created successfully!\033[0m"

  # 💡 Activate environment and install Qiskit
  case $terminal in
    0|1|2|3)
      echo -e "\033[1;36m⚡ Activating environment for Unix-like system...\033[0m"
      source ~/qiskit-env/bin/activate
      ;;
    4|5)
      echo -e "\033[1;36m⚡ Activating environment for Windows...\033[0m"
      source ~/qiskit-env/Scripts/activate
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
  if [[ -f "ibm-q/q.py" ]]; then
    echo -e "\033[1;32m🐍 Please wait while we prepare quantum account starter tool module.\033[0m"
    sleep 5
    python ibm-q/q.py
  else
    echo -e "\033[1;31m❌ File 'ibm-q starter module' does NOT exist.\033[0m"
    exit 0
  fi
}

# 📦 Install Required Qiskit Packages
package_install() {
    print_step "Upgrading pip, setuptools, and wheel..."
    pip install --upgrade pip setuptools wheel
    print_step "Installing Qiskit packages..."
    pip install qiskit
    pip install qiskit-aer
    pip install qiskit-algorithms
    pip install qiskit-ibm-runtime
    pip install qiskit-nature
    pip install qiskit-nature-pyscf
    pip install qiskit-serverless
    pip install matplotlib
    pip install jupyter
    pip install qiskit-ibm-catalog
    pip install python-dotenv
    pip install qiskit-ibm-provider
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
    . ~/qiskit-env/bin/activate
    print_step "Installed Qiskit Packages:"
    pip list | grep qiskit
    echo -e "🧪 You can now start developing quantum solutions using Qiskit!\033[0m"
    echo -e "🧪 To start your quantum qiskit environment, run any of these:\033[0m"
    echo -e "🖥️ For Linux: source ~/qiskit-env/bin/activate\033[0m"
    echo -e "🖥️ For MacOS: source ~/qiskit-env/bin/activate\033[0m"
    echo -e "🖥️ For Windows: source ~/qiskit-env/Scripts/activate\033[0m"
    echo -e "🧪 To open your notebook: jupyter notebook <path/to/notebook.ipynb>\033[0m"
}
main
