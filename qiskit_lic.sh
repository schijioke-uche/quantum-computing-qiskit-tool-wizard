#!/usr/bin/env bash
#---------------------------------------------------------------------------------------------------------------------
#                                   IBM QUANTUM COMPUTING QISKIT SOFTWARE
#---------------------------------------------------------------------------------------------------------------------
# @Author:   Dr. Jeffrey Chijioke-Uche, IBM Computer Scientist, Quantum Ambassador, and Qiskit Advocate
# @Usage:    Install Qiskit software and its dependencies
# @License:  Qiskit Tool License

# Set project root early — before any functions
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# License agreement function
license_accept() {
  local BND="-------------------------------------------------------------------------------------------------------------------------------------------"
  local LIC="--------------------------------------------------------------------------------------------------------------------"
  local LICENSE_FILE="$ROOT_DIR/LICENSE"
  local STORE_DIR="$ROOT_DIR/license-accepted"

  echo ''
  echo "$BND"
  echo "📄 LICENSE AGREEMENT"
  echo "$BND"

  # Ensure LICENSE exists in project root
  if [[ -f "$LICENSE_FILE" ]]; then
    cat "$LICENSE_FILE"
  else
    echo "❌ License file not found in project root: $LICENSE_FILE"
    echo ''
    exit 1
  fi

  echo ''
  echo "$BND"
  read -rp "Do you accept the terms of the license? [accept/decline]: " user_input

  case "$user_input" in
    accept|ACCEPT|Accept)
      echo "✅ License accepted. Proceeding with Qiskit software installation..."
      local accepted_date
      accepted_date=$(date +"%m-%d-%Y")
      mkdir -p "$STORE_DIR"

      # Signature metadata
      local user_ip
      user_ip=$(hostname -I | awk '{print $1}')
      local timestamp
      timestamp=$(date +"%Y-%m-%d %H:%M:%S")
      local license_hash
      license_hash=$(echo -n "$user_ip-$timestamp" | sha256sum | awk '{print $1}')
      local accepted_file="$STORE_DIR/license-accepted-$accepted_date"

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
}

# Run
license_accept
