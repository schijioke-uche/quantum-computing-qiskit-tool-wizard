
#!/usr/bin/env bash

#--------------------------------------------------------
# @Project: Quantum Computing Qiskit v2.x Tool Wizard
# @Technology: Quantum Computing, Qiskit
# @File: qiskit-v2x-install-wizard.sh
# @Description: Qiskit v2.x Installer Wizard
# @Version: 1.0.0
# @Date: 2024-01-01
# @License: Apache-2.0
# @Title: Qiskit v2.x Installer Wizard
# @Author: Dr. Jeffrey Chijioke-Uche, IBM Quantum Ambassador
#--------------------------------------------------------
set -e

check_status_qtool_wizard() {
  CHECK_STORE_DIR="$ROOT_DIR/license-accepted"
  check_accepted_file="$CHECK_STORE_DIR/qwizard-license-accepted-$(date +"%m-%d-%Y")"
  match_found=

  # Loop with RegEx:.
  for file in "$CHECK_STORE_DIR"/*; do
    filename=$(basename "$file")
    if [[ "$filename" =~ qwizard-license-accepted- ]]; then
      echo -e "\n\033[1;34m${QTOOL_WIZARD}\033[0m"
      return 0
    fi
  done
}

