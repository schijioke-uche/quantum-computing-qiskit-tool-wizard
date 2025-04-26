# @author: Dr. Jeffrey Chijioke-Uche, IBM Quantum Ambassador & Researcher
# @Software: Qiskit v2.x Starter Tool wizard


#------------------------------------------------------------------------------------------------
# This file is used to store environment variables for the Qiskit installation wizard: Update it.
# The "ibm_quantum" channel option is deprecated and will be sunset on 1 July 2025. 
# After this date, ibm_cloud will be the only valid channel. 
# For information on migrating to the new IBM Quantum Platform on the "ibm_cloud" channel, 
# review the migration guide https://quantum.cloud.ibm.com/docs/migration-guides/classic-iqp-to-cloud-iqp .
#-----------------------------------------------------------------------------------------------------


# GENERAL PURPOSE USE:
#--------------------------------------------
IQP_API_TOKEN="<PROVIDE PLAN IQP API TOKEN or IBM QUANTUM API KEY>"  


# Default (Open plan) - free monthly 10mins Runtime.
OPEN_PLAN_CHANNEL="<PROVIDE CHANNEL NAME>"
OPEN_PLAN_INSTANCE="<PROVIDE INSTANCE AS CRN STRING>" # [Must be a CRN string].
OPEN_PLAN_NAME="open"


# Optional (Upgrade) - Standard Plan
STANDARD_PLAN_CHANNEL="<PROVIDE CHANNEL NAME>"  # After July 1, 2025, use ibm_cloud
STANDARD_PLAN_INSTANCE="<PROVIDE INSTANCE NAME>"
STANDARD_PLAN_NAME="standard"
STANDARD_IQP_API_URL=https://auth.quantum-computing.ibm.com/api/users/loginWithToken
STANDARD_IQP_BACKEND_URL=https://api.quantum-computing.ibm.com/runtime/backends


# Optional (Upgrade) - Premium Plan
PREMIUM_PLAN_CHANNEL="<PROVIDE CHANNEL NAME>"
PREMIUM_PLAN_INSTANCE="<PROVIDE INSTANCE AS HUB/PROJECT/ASSET PATH>"
PREMIUM_PLAN_NAME="premium"
PREMIUM_IQP_API_URL="https://auth.quantum-computing.ibm.com/api/users/loginWithToken"  # Update this URL if needed
PREMIUM_IQP_BACKEND_URL="https://api.quantum-computing.ibm.com/runtime/backends"  # Update this URL if needed


# Optional (Upgrade) - Dedicated Plan
DEDICATED_PLAN_CHANNEL="<PROVIDE CHANNEL NAME>"
DEDICATED_PLAN_INSTANCE="<PROVIDE INSTANCE AS HUB/PROJECT/ASSET PATH>"
DEDICATED_PLAN_NAME="dedicated"
DEDICATED_IQP_API_URL="https://auth.quantum-computing.ibm.com/api/users/loginWithToken"  # Update this URL if needed
DEDICATED_IQP_BACKEND_URL="https://api.quantum-computing.ibm.com/runtime/backends"  # Update this URL if needed


# Switch "on" one plan: Use one or the other at a time. You cannot switch ALL "on" at the same time.
#--------------------------------------------------------------------------------------------------
OPEN_PLAN="on"       # [Default & switched on] This plan is free - Signup :  https://quantum.cloud.ibm.com 
STANDARD_PLAN="off"   # This plan is paid. Switched "Off" by default - Turn it "on" after purchase.   
PREMIUM_PLAN="off"     # This plan is paid. Switched "Off" by default - Turn it "on" after purchase.   
DEDICATED_PLAN="off"  # This plan is paid. Switched "Off" by default - Turn it "on" after purchase.   
