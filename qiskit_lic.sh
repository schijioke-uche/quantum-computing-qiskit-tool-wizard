#!/usr/bin/env bash
#---------------------------------------------------------------------------------------------------------------------
#                                   IBM QUANTUM COMPUTING QISKIT SOFTWARE
#---------------------------------------------------------------------------------------------------------------------
# @Author:   Dr. Jeffrey Chijioke-Uche, IBM Computer Scientist, Quantum Ambassador, and Qiskit Advocate
# @Usage:    Install Qiskit software and its dependencies
# @License:  Qiskit Tool License

source ./lib/wizard.sh
# Set project root early — before any functions
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

print_step()     { echo -e "\n\033[1;36m🔹 $1\033[0m"; }
print_success()  { echo -e "\033[1;32m✅ $1\033[0m"; }
print_error()    { echo -e "\033[1;31m❌ $1\033[0m"; }
print_warning()  { echo -e "\033[1;33m⚠️  $1\033[0m"; }
print_notice()   { echo -e "\033[1;35m📌 $1\033[0m"; }
print_running()  { echo -e "\033[1;34m🏃 $1\033[0m"; }
print_info()     { echo -e "\033[1;37mℹ️  $1\033[0m"; }
print_special_notice()  { echo -e "\033[1;37m$1\033[0m"; }
print_special_success() { echo -e "\033[1;32m$1\033[0m"; }
print_special_info()     { echo -e "\033[1;34m  $1\033[0m"; }

#---------------------------------------------------------------------------------------------------------------------
# License agreement function
license_accept() {
  local BND="----------------------------------------------------------------------------------------------------------------------------"
  local LIC="--------------------------------------------------------------------------------------------------------------------"
  local LICENSE_FILE="$ROOT_DIR/LICENSE"
  local STORE_DIR="$ROOT_DIR/license-accepted"
  local accepted_date
  accepted_date=$(date +"%m-%d-%Y")
  local accepted_file="$STORE_DIR/qwizard-license-accepted-$accepted_date"

  print_special_notice "$BND"
  print_special_success "📄 LICENSE AGREEMENT"
  print_special_notice "$BND"

  # Check if license was previously accepted
  if [[ -f "$accepted_file" ]]; then
    print_special_info "License previously accepted on: $accepted_date"
    return 0
  fi

  # Show license content
  if [[ -f "$LICENSE_FILE" ]]; then
    cat "$LICENSE_FILE"
  else
    print_error "License file not found in project root: $LICENSE_FILE"
    exit 1
  fi

  echo "$BND"
  read -rp "Do you accept the terms of the license? [accept/decline]: " user_input

  case "$user_input" in
    accept|ACCEPT|Accept)
      # Clear screen or push license content off screen
      sleep 1
      clear || for i in {1..30}; do echo ""; done

      
     
      mkdir -p "$STORE_DIR"
      local user_ip
      user_ip=$(hostname -I | awk '{print $1}')
      local timestamp
      timestamp=$(date +"%Y-%m-%d %H:%M:%S")
      local license_hash
      license_hash=$(echo -n "$user_ip-$timestamp" | sha256sum | awk '{print $1}')

      {
        echo "STATUS: ACCEPTED"
        echo "DATE ACCEPTED: $(date +"%m/%d/%Y %H:%M:%S")"
        echo "HOST IP ADDRESS: $user_ip"
        echo "UNIQUE HASH/E-SIGNATURE: $license_hash"
        echo "$LIC"
        cat "$LICENSE_FILE"
      } > "$accepted_file"
      ;;
    decline|DECLINE|Decline)
      echo "❌ License declined. Exited process. Qiskit software not installed."
      exit 0
      ;;
    *)
      echo "⚠️ Invalid input. Please type 'accept' or 'decline'."
      exit 1
      ;;
  esac
  
  #  [Display the Banner after license acceptance]
  check_status_qtool_wizard
  print_success "License accepted. Proceeding with Qiskit software installation..."
}

#---------------------------------------------------------------------------------------------------------------------
# Run
license_accept


