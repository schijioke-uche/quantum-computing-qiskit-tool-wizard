#!/usr/bin/env bash
#---------------------------------------------------------------------------------------------------------------------
#                                 IBM QUANTUM QISKIT SOFTWARE TOOL INSTALLATION
#---------------------------------------------------------------------------------------------------------------------
# @Author:   Dr. Jeffrey Chijioke-Uche, IBM
# @Usage:    Install Qiskit software and its dependencies
# @License:  Qiskit Tool License

# License agreement:
license_accept() {
  BND="-----------------------------------------------------------------------------------------------------------------------------------------------"
  LIC="--------------------------------------------------------------------------------------------------------------------"
  LICENSE_FILE="$ROOT_DIR/LICENSE"
  STORE_DIR="$ROOT_DIR/logs"

  echo ''
  echo "$BND"
  echo "📄 LICENSE AGREEMENT"
  echo "$BND"

  if [[ -f "$LICENSE_FILE" ]]; then
    cat "$LICENSE_FILE"
  else
    echo "❌ License file not found: $LICENSE_FILE"
    echo ''
    exit 1
  fi

  echo ''
  echo "$BND"
  read -rp "Do you accept the terms of the license? [accept/decline]: " user_input

  case "$user_input" in
    accept|ACCEPT|Accept)
      echo "✅ License accepted. Proceeding with Qiskit software installation..."
      accepted_date=$(date +"%m-%d-%Y")
      mkdir -p "$STORE_DIR"
      accepted_file="$STORE_DIR/license-accepted-$accepted_date"
      {
        echo "STATUS: ACCEPTED"
        echo "DATE ACCEPTED: $(date +"%m/%d/%Y")"
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
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
license_accept
