
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


QTOOL_WIZARD=$(cat << 'EOF'
                                    Qiskit® Starter Tool Wizard For Qiskit Installation & Virtual Environment Setup
        ______       __       _______. __  ___  __  .___________.   ____    __    ____  __   ________       ___      .______       _______  
       /  __  \     |  |     /       ||  |/  / |  | |           |   \   \  /  \  /   / |  | |       /      /   \     |   _  \     |       \ 
      |  |  |  |    |  |    |   (----`|  '  /  |  | `---|  |----`    \   \/    \/   /  |  | `---/  /      /  ^  \    |  |_)  |    |  .--.  |
      |  |  |  |    |  |     \   \    |    <   |  |     |  |          \            /   |  |    /  /      /  /_\  \   |      /     |  |  |  |
      |  `--'  '--. |  | .----)   |   |  .  \  |  |     |  |           \    /\    /    |  |   /  /----. /  _____  \  |  |\  \----.|  '--'  |
       \_____\_____\|__| |_______/    |__|\__\ |__|     |__|            \__/  \__/     |__|  /________|/__/     \__\ | _| `._____||_______/ 

                                                  Quantum Computing Qiskit Tool Wizard®
EOF
)

export QT_WIZARD="${QTOOL_WIZARD}"