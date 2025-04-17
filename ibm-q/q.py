# Author: Dr. Jeffrey Chijioke-Uche, IBM Quantum Ambassado
import os
import requests
import warnings
from qiskit_ibm_runtime import QiskitRuntimeService
from datetime import datetime
from dotenv import load_dotenv
#-------------------------
# Load environment variabes
load_dotenv()
print('')

#--------------------------
# Credential map 
# Load from environment (safely)
is_open = os.getenv("OPEN_PLAN")
is_premium = os.getenv("PREMIUM_PLAN")

# Determine active plan type
bnd = '\n------------------------------------------------------------------------------------------------------------------'
if is_open == "on":
    connect = "open"
    tag = "Open Plan"
elif is_premium == "on":
    connect = "premium"
    tag = "Premium Plan"
else:
    raise ValueError("❌ No valid plan is activated. Set OPEN_PLAN or PREMIUM_PLAN to 'on'.")

# Credential map
credentials = {
    "open": {
        "name": os.getenv("OPEN_PLAN_NAME"),
        "channel": os.getenv("OPEN_PLAN_CHANNEL"),
        "instance": os.getenv("OPEN_PLAN_INSTANCE"),
        "token": os.getenv("IQP_API_TOKEN")
    },
    "premium": {
        "name": os.getenv("PREMIUM_PLAN_NAME"),
        "channel": os.getenv("PREMIUM_PLAN_CHANNEL"),
        "instance": os.getenv("PREMIUM_PLAN_INSTANCE"),
        "token": os.getenv("IQP_API_TOKEN")
    }
}
active_plan = credentials[connect]
 
#------------------------------------------------------------------
# Quantum Session Account for a given plan type
def set_plan(plan_type=connect):
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
        print(f'{bnd}')
        print(f'✅ {tag} IBM Quantum Account Plan Backend Connection Established Successfully!')
        print(f"✅ Plan Type: {plan_type} plan")
    except Exception as e:
        print(f"ℹ️ Provider message for token api-login & compute resources view: {e}")

#------------------------------------------------
# Authenticate into Premium Plan Account
#------------------------------------------------
def premium_connect():
    """
    Authenticate to IBM Quantum Premium Plan and list available backend devices.
    Requires 'IQP_API_TOKEN', 'PREMIUM_IQP_API_URL', and 'PREMIUM_IQP_BACKEND_URL' to be set.
    """
    try:
        token = os.environ.get("IQP_API_TOKEN", "").strip()
        url = os.environ.get("PREMIUM_IQP_API_URL", "").strip()

        if not token or not url:
            print("❌ Required environment variables 'IQP_API_TOKEN' or 'PREMIUM_IQP_API_URL' are missing or empty.")
            return

        payload = {"apiToken": token}

        # Attempt authentication
        auth_response = requests.post(url, json=payload)
        auth_response.raise_for_status()

        json_data = auth_response.json()
        auth_id = json_data.get('id')

        if auth_id:
            print(f'{bnd}')
            print(f'✅ {tag} Plan IBM Quantum Account Plan Backend Connection Established Successfully!')
            print(f"✅ Authentication Successful & Premium Connection ID: {auth_id}")
        else:
            print("⚠️ 'id' field not found in the authentication response.")
            return

    except requests.exceptions.RequestException as e:
        print(f"❌ Network or HTTP error occurred during authentication: {e}")
        return
    except ValueError:
        print("❌ Failed to parse authentication JSON response.")
        return
    except Exception as e:
        print(f"❌ Unexpected authentication error: {e}")
        return

    # Fetch premium backend computing resources
    try:
        backend_url = os.environ.get("PREMIUM_IQP_BACKEND_URL", "").strip()
        if not backend_url:
            print("⚠️ Environment variable 'PREMIUM_IQP_BACKEND_URL' is missing or empty.")
            return

        headers = {
            'Content-Type': 'application/json',
            'x-access-token': auth_id
        }

        backends_response = requests.get(backend_url, headers=headers)
        backends_response.raise_for_status()

        devices = backends_response.json().get('devices', [])
        if devices:
            devices = devices[:5]
            preferred_qpu = "ibm_brisbane" if "ibm_brisbane" in devices else None

            print("🔧 Your Top 5 available premium plan account backend devices:")
            for device in devices:
                print(f"- {device}")

            if preferred_qpu:
                print(f"🎯 Preferred QPU backend: {preferred_qpu}")
            else:
                print("\n⚠️ 'ibm_brisbane' not found — no preferred QPU selected.")
        else:
            print("⚠️ No backend devices returned in response.")

    except requests.exceptions.RequestException as e:
        print(f"❌ Error retrieving backend devices: {e}")
    except ValueError:
        print("❌ Failed to parse backend devices JSON response.")
    except Exception as e:
        print(f"❌ Unexpected error while fetching backend list: {e}")


#------------------------------------------------------------------
# General focus backend QPUs Information
#------------------------------------------------------------------
def focus_qpu():
    try:
        # effective Juy 1 2025, removed the warning filter & use ibm_cloud as channel for Premium Plan.
        with warnings.catch_warnings():
            warnings.filterwarnings("ignore", category=DeprecationWarning)
            service = QiskitRuntimeService()
            qpus = service.backends()
            qpu_names = [qpu.name for qpu in qpus]
            preferred_qpu = "ibm_brisbane"

        if service and not qpu_names:
            print(f"\n⚛️ Quantum Plan Backend Connection Information")
            premium_connect()
            return

        print("⚛️ IBM Quantum Backend Compute Resources With Available QPUs:")
        for name in qpu_names:
            print(f"- {name}")

        backend_name = preferred_qpu if preferred_qpu in qpu_names else qpu_names[0]
        if backend_name != preferred_qpu:
            print(f"ℹ️ Preferred backend '{preferred_qpu}' not found. Falling back to '{backend_name}'")

        backend = service.backend(backend_name)
        print(
            f"✅ Version: {getattr(backend, 'version', 'N/A')}\n"
            f"✅ Number of Qubits: {getattr(backend, 'num_qubits', 'N/A')}\n"
            f"🎯 Preferred QPU backend: {backend.name}\n"
        )
    except Exception as e:
        print(f"ℹ️ Quantum hardware Provider's Message: {e}")

#------------------------------------------------
# Footer
def footer():
    today = datetime.today().strftime("%Y")
    print(f"\nDesign by: Dr. Jeffrey Chijioke-Uche, IBM Quantum Ambassador\nIBM Quantum Qiskit Software - All Rights Reserved ©{today}\n")

#----------------------------
# Execute when run as script
#----------------------------
if __name__ == "__main__":
    set_plan(connect) 
    focus_qpu()
    footer()