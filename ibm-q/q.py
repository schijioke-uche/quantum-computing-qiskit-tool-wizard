# Author: Dr. Jeffrey Chijioke-Uche, IBM Quantum Ambassador

from qiskit_ibm_runtime import QiskitRuntimeService
from qiskit_ibm_catalog import QiskitFunctionsCatalog
from datetime import datetime
import os
from dotenv import load_dotenv

#------------------------------------------------------------------
# Load environment variabes
load_dotenv()
print('')

# Credential map for Open and Premium plans
# Load from environment (safely)
is_open = os.getenv("OPEN_PLAN")
is_premium = os.getenv("PREMIUM_PLAN")

# Determine active plan type
if is_open == "on":
    connect = "open"
elif is_premium == "on":
    connect = "premium"
else:
    raise ValueError("❌ No valid plan is activated. Set OPEN_PLAN or PREMIUM_PLAN to 'on'.")

# Credential map
credentials = {
    "open": {
        "name": os.getenv("OPEN_PLAN_NAME"),
        "channel": os.getenv("OPEN_PLAN_CHANNEL"),
        "instance": os.getenv("OPEN_PLAN_INSTANCE"),
        "token": os.getenv("OPEN_PLAN_IQP_API_TOKEN")
    },
    "premium": {
        "name": os.getenv("PREMIUM_PLAN_NAME"),
        "channel": os.getenv("PREMIUM_PLAN_CHANNEL"),
        "instance": os.getenv("PREMIUM_PLAN_INSTANCE"),
        "token": os.getenv("PREMIUM_IQP_API_TOKEN")
    }
}

# Access the correct credentials
active_plan = credentials[connect]
 
#------------------------------------------------------------------
# Quantum Session Account for a given plan type
def set_plan(plan_type="open"):
    try:
        cred = credentials[plan_type]
        QiskitRuntimeService.save_account(
            channel=cred["channel"],
            token=cred["token"],
            instance=cred["instance"],
            name=cred["name"],
            set_as_default=True,
            overwrite=True,
            verify=True
        )
        print(f'✅ IBM Quantum Account Plan Backend Connection Established!')
        print(f"✅ Plan Type: {plan_type} plan")
    except Exception as e:
        print(f"ℹ️ Provider message for token api-login & compute resources view: {e}")

#------------------------------------------------------------------
# Get Available QPU and Display Info
def focus_qpu():
    try:
        service = QiskitRuntimeService()
        qpus = service.backends()
        qpu_names = [qpu.name for qpu in qpus]
        preferred_qpu = "ibm_brisbane"

        if service and not qpu_names:
            print("ℹ️ Your Quantum hardware provider did not authorize you to list backend compute resources at this time for api accessed with token.")
            print(f"ℹ️ Default QPU backend: {preferred_qpu if preferred_qpu else 'None'}")
            return

        print("⚛️ IBM Quantum Backend Compute Resources With Available QPUs:")
        for name in qpu_names:
            print(f"- {name}")

        backend_name = preferred_qpu if preferred_qpu in qpu_names else qpu_names[0]
        if backend_name != preferred_qpu:
            print(f"ℹ️ Preferred backend '{preferred_qpu}' not found. Falling back to '{backend_name}'")

        backend = service.backend(backend_name)
        print(
            f"✅ Connected to backend: {backend.name}\n"
            f"✅ Version: {getattr(backend, 'version', 'N/A')}\n"
            f"✅ Number of Qubits: {getattr(backend, 'num_qubits', 'N/A')}"
        )
    except Exception as e:
        print(f"ℹ️ Quantum hardware Provider's Message: {e}")

#------------------------------------------------
# Footer
def footer():
    today = datetime.today().strftime("%Y")
    print(f"\nDesign by: Dr. Jeffrey Chijioke-Uche, IBM Quantum Ambassador\nIBM Quantum Qiskit Software - All Rights Reserved ©{today}\n")

#------------------------------------------------
if __name__ == "__main__":
    set_plan(connect)  # ✅ Pass "open" or "premium" string.
    focus_qpu()
    footer()

