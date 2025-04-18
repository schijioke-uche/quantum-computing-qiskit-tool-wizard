# @author: Dr. Jeffrey Chijioke-Uche, IBM Quantum Ambassador & Researcher
# @Software: Qiskit v2.x Starter Tool wizard


#------------------------------------------------------------------------------------------------
# This file is used to store environment variables for the Qiskit installation wizard: Update it.
# The "ibm_quantum" channel option is deprecated and will be sunset on 1 July 2025. 
# After this date, ibm_cloud will be the only valid channel. 
# For information on migrating to the new IBM Quantum Platform on the "ibm_cloud" channel, 
# review the migration guide https://quantum.cloud.ibm.com/docs/migration-guides/classic-iqp-to-cloud-iqp .
#-----------------------------------------------------------------------------------------------------


# Default (Open plan) - free
OPEN_PLAN_CHANNEL="<PROVIDE CHANNEL NAME>"
OPEN_PLAN_INSTANCE="<PROVIDE INSTANCE AS CRN STRING>" # Must be a CRN string.
OPEN_PLAN_NAME="<PROVIDE PLAN NAME>"


# GENERAL PURPOSE
#--------------------------------------------
IQP_API_TOKEN="<PROVIDE IQP API TOKEN>"  


# Optional (Upgrade) - Premium
PREMIUM_PLAN_CHANNEL="<PROVIDE CHANNEL NAME>"
PREMIUM_PLAN_INSTANCE="<PROVIDE INSTANCE AS HUB/PROJECT/ASSET PATH>"
PREMIUM_PLAN_NAME="<PROVIDE PLAN NAME>"
PREMIUM_IQP_API_URL="https://auth.quantum-computing.ibm.com/api/users/loginWithToken"  # Update this URL if needed
PREMIUM_IQP_BACKEND_URL="https://api.quantum-computing.ibm.com/runtime/backends"  # Update this URL if needed



# Uncomment to turn-on one plan: Use one or the other at a time. You can upgrade to the premium plan later.
#----------------------------------------------------------------------------------------------------------
OPEN_PLAN = "on"        # [Default] This plan is free - Signup :  https://quantum.cloud.ibm.com 
#PREMIUM_PLAN = "on"    # [Upgrade] This plan is paid.   https://quantum.cloud.ibm.com
