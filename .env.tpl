# @author: Dr. Jeffrey Chijioke-Uche, IBM Quantum Ambassador & Researcher
# This file is used to store environment variables for the Qiskit installation wizard: Update it.
# The "ibm_quantum" channel option is deprecated and will be sunset on 1 July 2025. 
# After this date, ibm_cloud will be the only valid channel. 
# For information on migrating to the new IBM Quantum Platform on the "ibm_cloud" channel, 
# review the migration guide https://quantum.cloud.ibm.com/docs/migration-guides/classic-iqp-to-cloud-iqp .


# GENERAL PURPOSE
#--------------------------------------------
IQP_API_TOKEN=""  

# Channels:
#------------------------------------------
OPEN_PLAN_CHANNEL=""
PAID_PLAN_CHANNEL=""  # After July 1, 2025, use ibm_cloud for Paid Plans.


# API Access:
#-------------------------------------
IQP_API_URL=""
IQP_RUNTIME_BACKEND_URL=""


# Quantum Url:
#-------------------------------------
CLOUD_API_URL=""
QUANTUM_API_URL="" 
#The API URL. Defaults to https://cloud.ibm.com (ibm_cloud) or https://auth.quantum.ibm.com/api (ibm_quantum)


# Instance:
#-------------------------------------
OPEN_PLAN_INSTANCE=""
PAID_PLAN_INSTANCE=""


# Default (Open plan) - free
#----------------------------------------
OPEN_PLAN_NAME="open"


# Optional (Upgrade) - Pay-As-You-Go
#-----------------------------------------
PAYGO_PLAN_NAME="pay-as-you-go"  


# Optional (Upgrade) - Flex
#-----------------------------------------
FLEX_PLAN_NAME="flex"   


# Optional (Upgrade) - Premium
#-----------------------------------------
PREMIUM_PLAN_NAME="premium"    


# Optional (Upgrade) - Dedicated
#-----------------------------------------
DEDICATED_PLAN_NAME="dedicated"      


# Switch "on" one plan: Use one or the other at a time. You cannot switch both on at the same time.
#--------------------------------------------------------------------------------------------------
OPEN_PLAN="on"       # [Default & switched on] This plan is free - Signup :  https://quantum.cloud.ibm.com 
FLEX_PLAN="off"   # This plan is paid. Switched "Off" by default - Turn it "on" after purchase.   
PAYGO_PLAN="off"   # This plan is paid. Switched "Off" by default - Turn it "on" after purchase.   
PREMIUM_PLAN="off"     # This plan is paid. Switched "Off" by default - Turn it "on" after purchase.   
DEDICATED_PLAN="off"  # This plan is paid. Switched "Off" by default - Turn it "on" after purchase.   