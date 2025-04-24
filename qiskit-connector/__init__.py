# @Author: Dr. Jeffrey Chijioke-Uche, IBM Quantum Ambassador
# @Python package: Qiskit 2.x Connector 0.0.1
# @Availability:  In Pypi.org
#--------------------------------------------------------------------------

import os
import requests
import warnings
from qiskit_ibm_runtime import QiskitRuntimeService, IBMBackend
from datetime import datetime
from dotenv import load_dotenv
#-------------------------
# Load environment variabes
load_dotenv()
print('')


#------------------------------------------------------------------
# Load from environment (safely): Off by default.
#------------------------------------------------------------------
is_open = os.getenv("OPEN_PLAN", "off") 
is_premium = os.getenv("PREMIUM_PLAN", "off")
is_standard = os.getenv("STANDARD_PLAN", "off")
is_dedicated = os.getenv("DEDICATED_PLAN", "off")


#------------------------------------------------------------------
# Determine active plan type
#------------------------------------------------------------------
bnd = '\n------------------------------------------------------------------------------------------------------------------'

if is_open == "on":
    connect = os.getenv("OPEN_PLAN_NAME")
    tag = "Open Plan"
elif is_premium == "on":
    connect = os.getenv("PREMIUM_PLAN_NAME")
    tag = "Premium Plan"
elif is_standard == "on":
    connect = os.getenv("STANDARD_PLAN_NAME")
    tag = "Standard Plan"
elif is_dedicated == "on":
    connect = os.getenv("DEDICATED_PLAN_NAME")
    tag = "Dedicated Plan"
else:
    raise ValueError(f"⛔ No valid plan is activated. Set OPEN_PLAN or PREMIUM_PLAN to 'on'.")

# -- Headers --
header_1 = "\n⚛️ Quantum Plan Backend Connection IBMBackend QPUs Compute Resources Information:"
empty_return_notice_header = "⚛️ [QPU EMPTY RETURN NOTICE]:"

#------------------------------------------------------------------
# Quantum Plan mapping:
#------------------------------------------------------------------
criteria_to_use = {
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
    },
    "standard": {
        "name": os.getenv("STANDARD_PLAN_NAME"),
        "channel": os.getenv("STANDARD_PLAN_CHANNEL"),
        "instance": os.getenv("STANDARD_PLAN_INSTANCE"),
        "token": os.getenv("IQP_API_TOKEN")
    },
    "dedicated": {
        "name": os.getenv("DEDICATED_PLAN_NAME"),
        "channel": os.getenv("DEDICATED_PLAN_CHANNEL"),
        "instance": os.getenv("DEDICATED_PLAN_INSTANCE"),
        "token": os.getenv("IQP_API_TOKEN")
    }
}
is_open_on    = is_open
is_premium_on = is_premium
is_standard_on = is_standard
is_dedicated_on = is_dedicated
active_plan = criteria_to_use[connect]
switched_on_plan = is_open_on or is_premium_on or is_dedicated_on or is_standard_on
paid_plan_on = is_premium_on or is_dedicated_on or is_standard_on
free_plan_on = is_open_on

#------------------------------------------------------------------
# Quantum Connection Save For Reuse:
#------------------------------------------------------------------
def qiskit_save_connection(plan_type_on=connect):
    try:
        criterion = criteria_to_use[plan_type_on]
        QiskitRuntimeService.save_account(
            channel=criterion["channel"],
            token=criterion["token"],
            instance=criterion["instance"],
            name=criterion["name"],
            set_as_default=True,
            overwrite=True,
            verify=True
        )
        # -- Plan Instance ---
        open_focused_instance = os.getenv("OPEN_PLAN_INSTANCE", "")
        standard_focused_instance = os.getenv("STANDARD_PLAN_INSTANCE", "")
        premium_focused_instance = os.getenv("PREMIUM_PLAN_INSTANCE", "")
        dedicated_focused_instance = os.getenv("DEDICATED_PLAN_INSTANCE", "")

        if plan_type_on == "open":
            plan_instance = open_focused_instance
        elif plan_type_on == "standard":
            plan_instance = standard_focused_instance
        elif plan_type_on == "premium":
            plan_instance = premium_focused_instance
        elif plan_type_on == "dedicated":
            plan_instance = dedicated_focused_instance
        else:
            print("No Plan Specified")

        print(f'{bnd}')
        print("\nQuantum Processing Units (QPUs) Connection Status - Qiskit v2.x")
        print(f'{bnd}')
        # effective Juy 1 2025, removed the warning filter & use ibm_cloud as channel for Premium Plan.
        with warnings.catch_warnings():
            warnings.filterwarnings("ignore", category=DeprecationWarning)
            confirmation = QiskitRuntimeService()
        if confirmation: # Verify
            print(f"⚛️ Your Quantum Plan Type:  ✅ {plan_type_on.capitalize()} Plan")
            print(f"⚛️ {tag} Connection Status: ✅ QPU backend connection established successfully!")
            print(f"⚛️ {plan_type_on.capitalize()} Plan Instance: ✅ {plan_instance}\n\n")
        else:
            print(f'⛔ {tag} IBM Quantum Account Plan Backend Connection & Save Failed!')
    except Exception as e:
        print(f"ℹ️ Provider's message: {e}")



#-----------------------------------------------------------------------------------------
# Authenticate into Paid Plan Account via API
#-----------------------------------------------------------------------------------------
def paid_plans():
    """
    Authenticate to IBM Quantum Premium Plan and list available backend devices.
    Requires 'IQP_API_TOKEN', 'PREMIUM_IQP_API_URL', and 'PREMIUM_IQP_BACKEND_URL' to be set.
    """
    try:
        token = os.environ.get("IQP_API_TOKEN", "").strip()
        url = os.environ.get("PREMIUM_IQP_API_URL", "").strip()

        if not token or not url:
            print(f"⛔ Required environment variables 'IQP_API_TOKEN' or 'PREMIUM_IQP_API_URL' are missing or empty.")
            return

        payload = {"apiToken": token}

        # Attempt authentication
        auth_response = requests.post(url, json=payload)
        auth_response.raise_for_status()

        json_data = auth_response.json()
        auth_id = json_data.get('id')

        if auth_id:
            print(f'{bnd}')
            print(f"⚛️ Your Quantum Plan Type: {tag}")
            print(f'✅ {tag} Plan IBM Quantum Account Plan Backend Connection Established Successfully!')
            print(f"✅ Authentication Successful & Premium Connection ID: {auth_id}")
        else:
            print("⚠️ 'id' field not found in the authentication response.")
            return

    except requests.exceptions.RequestException as e:
        print(f"⛔ Network or HTTP error occurred during authentication: {e}")
        return
    except ValueError:
        print("⛔ Failed to parse authentication JSON response.")
        return
    except Exception as e:
        print(f"⛔ Unexpected authentication error: {e}")
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

            print("🔧 Your Top 5 available premium plan IBMBackend QPUs:")
            for device in devices:
                print(f"- {device}")

            if preferred_qpu:
                print(f"🎯 Preferred QPU backend: {preferred_qpu}")
            else:
                print("\n⚠️ 'ibm_brisbane' not found — no preferred QPU selected.")
        else:
            print("⚠️ No backend devices returned in response.")

    except requests.exceptions.RequestException as e:
        print(f"⛔ Error retrieving backend devices: {e}")
    except ValueError:
        print("⛔ Failed to parse backend devices JSON response.")
    except Exception as e:
        print(f"⛔ Unexpected error while fetching backend list: {e}")



#---------------------------------------------------------------------------
# General QPUs Information: Criteria Verification
#---------------------------------------------------------------------------
def qpu_verify():
    try:
        # effective Juy 1 2025, removed the warning filter & use ibm_cloud as channel for Premium Plan.
        with warnings.catch_warnings():
            warnings.filterwarnings("ignore", category=DeprecationWarning)
            service = QiskitRuntimeService()
            qpus = service.backends()
            qpu_names = [qpu.name for qpu in qpus]
            preferred_qpu = "ibm_brisbane"

        if paid_plan_on == "on" and not qpu_names:
            print(header_1)
            print("⚛️ IBMBackend retuned empty List[] of QPU backends - P98903.")
            return

        elif paid_plan_on == "on" and qpu_names:
            print(header_1)
            paid_plans()  # [PAID PLAN API VERIFICATION SINCE IBMBACKEND FAILED]

        elif free_plan_on == "on" and not qpu_names:
            print(header_1)
            print("⚛️ IBMBackend retuned empty List[] of QPU backends - F98903.")
            return

        elif free_plan_on == "on" and qpu_names:
            print(f"⚛️ IBM Quantum {switched_on_plan} IBMBackend Compute Resources With Preferred QPU:")
            for name in qpu_names:
                print(f"- {name}")
        
            backend_name = preferred_qpu if preferred_qpu in qpu_names else qpu_names[0]
            if backend_name != preferred_qpu:
                print(f"ℹ️ Preferred backend '{preferred_qpu}' not found. Falling back to '{backend_name}'")
        
            backend = service.backend(backend_name)
            print(
                f"🖥️ Preferred QPU backend: {backend.name}\n"
                f"🖥️ Version: {getattr(backend, 'version', 'N/A')}\n"
                f"🖥️ Number of Qubits: {getattr(backend, 'num_qubits', 'N/A')}\n"
            )
        else:
            print("⚛️ Switched On Plan is Unknown - Contact your administrator")
    except Exception as e:
        print(f"ℹ️ Quantum hardware Provider's Message: {e}")




#-----------------------------------------------------------------------------
# Verify Connectivity
#-----------------------------------------------------------------------------
def is_verified():
    """
    Quantum backend connected device criteria verification & listing.
    """
    #1️⃣ Quantum backend connection (live QPU only): Realtime.
    try:
        with warnings.catch_warnings():
            warnings.filterwarnings("ignore", category=DeprecationWarning)
            service = QiskitRuntimeService()

        if is_open_on == "on" and is_premium_on == "off" and is_standard_on == "off" and is_dedicated_on == "off":
            switched_on_plan = "Open Plan"
            backend = service.least_busy(
                simulator=False,
                operational=True,
                min_num_qubits=5
            )
            if backend:
                print(f"⚛️ IBM Quantum {switched_on_plan} Backend Compute Resources With Least Busy QPU:")
                qpus = service.backends()
                qpu_names = [qpu.name for qpu in qpus]
                for device in qpu_names:
                    print(f"- {device}")
                print(
                    f"🖥️ Least Busy QPU backend device: {backend.name}\n"
                    f"🖥️ Version: {getattr(backend, 'version', 'N/A')}\n"
                    f"🖥️ Number of Qubits: {getattr(backend, 'num_qubits', 'N/A')}\n"
                    f"🖥️ Online Since: {getattr(backend, 'online_date', 'N/A')}\n"
                    )
                footer()
            else:
                print(f"⛔ {switched_on_plan}: Backend QPU device not accessible - E1033.")
                return
        elif is_premium_on == "on" or is_standard_on == "on" or is_dedicated_on == "on" and is_open_on == "off":
            switched_on_plan = "Premium Plan"
            instance = os.getenv("PREMIUM_PLAN_INSTANCE", "") 
            channel = os.getenv("PREMIUM_PLAN_CHANNEL", "") 
            url = os.getenv("IBM_QUANTUM_API_URL", "") 
            token = os.getenv("IQP_API_TOKEN", "") 
            with warnings.catch_warnings():
                warnings.filterwarnings("ignore", category=DeprecationWarning)
                service = QiskitRuntimeService(
                    instance=instance, 
                    channel=channel, 
                    url=url,
                    token=token,
                    verify=True
                    )
                # Try filter by instance first…
                IBMBackends = service.backends(
                    simulator=False,
                    operational=True,
                    instance=instance,
                    min_num_qubits=5
                    )
                #...if the IBMBackend list is Not Empty:
                if IBMBackends:
                    print("Raw premium backend list:", IBMBackends)
                    # Print just the names one‑per‑line:
                    print("Available premium filetered backends:")
                    for b in IBMBackends:
                        print(f"- {b.name}")
                        backend = IBMBackends[0]
                        print(f"⚛️ IBM Quantum {switched_on_plan} backend Compute Resources With Available QPUs:")
                        IBMBackend_names = [qpu.name for qpu in IBMBackends]
                        for device in IBMBackend_names:
                            print(f"- {device}")
                            print(
                                f"🖥️ First Available QPU backend device: {backend.name}\n"
                                f"🖥️ Version: {getattr(backend, 'version', 'N/A')}\n"
                                f"🖥️ Number of Qubits: {getattr(backend, 'num_qubits', 'N/A')}\n"
                                f"🖥️ Online Since: {getattr(backend, 'online_date', 'N/A')}\n"
                                ) 
                            footer()
                # …but if it’s empty,
                else:
                    print(empty_return_notice_header)
                    print("-" * 28 + "\n")
                    print(f"🔔 {switched_on_plan} Instance:", {instance})
                    print(f"🔔 Returned empty QPU IBMBackend list :", IBMBackends)
                    print(f"🔔 You do not have access to this {switched_on_plan} QPUs in {instance}.\n🔔 Contact your administrator for additional help.\n ")    
                    footer()
       #-----         
        else:
            print(f"⛔ Plan error: please activate exactly one of OPEN_PLAN or PREMIUM_PLAN (value='on').")
            return
    except Exception as e:
        print(f'⚛️ Open Plan is: {is_open_on}')
        print(f'⚛️ Premium Plan is: {is_premium_on}')
        print(f"⛔ Quantum {switched_on_plan}: Connected but could not retrieve quantum backend QPU device: {e}")
        footer()
        return


#------------------------------------------------
# Footer
#-------------------------------------------------
def footer():
    today = datetime.today().strftime("%Y")
    print(f"\nDesign by: Dr. Jeffrey Chijioke-Uche, IBM Quantum Ambassador\nIBM Quantum Qiskit Software - All Rights Reserved ©{today}\n")



#-------------------------------------------------
# Pypi Connector
#-------------------------------------------------
def connector() -> IBMBackend:
    """Save your account, list QPUs, pick one, and return it backend."""
    instance = os.getenv("OPEN_PLAN_INSTANCE", "") or os.getenv("STANDARD_PLAN_INSTANCE", "") or os.getenv("PREMIUM_PLAN_INSTANCE", "") or os.getenv("DEDICATED_PLAN_INSTANCE", "")

    # 2) Retrieve Saved load account:
    try:
        with warnings.catch_warnings():
            warnings.filterwarnings("ignore", category=DeprecationWarning)
            service = QiskitRuntimeService()  # [picks up your saved account]
    except Exception as e:
        print(f"⛔ Failed to initialize QiskitRuntimeService: {e}")
        return None

    # 3) Choose the right QPU:
    #backend = None
    if is_open_on == "on" and is_premium_on == "off" and is_dedicated == "off" and is_standard == "off":
        plan = "Open Plan"
        try:
            backend = service.least_busy(
                simulator=False,
                operational=True,
                min_num_qubits=5
            )
        except Exception as e:
            print(f"⛔ {plan}: no least‐busy QPU found: {e}")
            return None

    elif is_premium_on == "on" or is_standard == "on" or is_dedicated == "on" and is_open_on == "off":
        plan = "Paid Plan"
        available = service.least_busy(
            simulator=False,
            operational=True,
            instance=instance,
            min_num_qubits=5
        )
        if not available:
            print(f"⛔ {plan}: returned empty QPU list for instance '{instance}'")
            return None
        backend = available[0]
    else:
        print("⛔ Plan error: set exactly one of OPEN_PLAN or PREMIUM_PLAN = 'on'")
        return None

    # 4) Diagnostics / Confirmation:
    print("\n" + "-" * 82)
    print(f"⚛️  Connected [{plan}]  →  Realtime Least Busy QPU: {backend.name}")
    print("-" * 82)

    # list all available QPUs under this plan
    qpus = service.backends(
        simulator=False,
        operational=True,
        instance=(instance if plan == switched_on_plan else None)
    )
    print(f"⚛️ Available QPUs ({plan}):")
    for q in qpus:
        print(f"- {q.name}")
    print(f"🖥️  Default QPU: {backend.name}")
    print(f"🖥️  Qubit Version: {backend.version}")
    print(f"🖥️  Number of Qubits: {backend.num_qubits}")
    print("-" * 82 + "\n")
    footer()
    print("-" * 82 + "\n")

    return backend



#-------------------------------
# Plan
#-------------------------------
def plan_type():
    """
    Decide which execution plan is active.
    Exactly one of [OPEN_PLAN] vs. [PREMIUM_PLAN, STANDARD_PLAN, DEDICATED_PLAN]
    must be 'on'. Returns "Open Plan" or "Paid Plan", otherwise raises.

    Args:
        if paid_on == 'on' then plan is 'Paid Plan'
        if open_on == 'on' then plan is 'Open Plan'
    """
    # Already read from .env/vault above - No need to defined it again.
    open_on = is_open_on
    paid_on = is_premium_on or is_standard_on or is_dedicated_on
    

    if paid_on == "on" and not open_on:
        plan = "Paid Plan"
        return plan
    else:
        plan = "Open Plan"
        return plan


#--------------------------------
# Qiskit Connector Package Object
#--------------------------------
if __name__ == "__main__":
    #qiskit_save_connection(connect) 
    #qpu_verify()
    #print('\n')
    #is_verified()
    connector()
 