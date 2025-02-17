# aro
aro install script in 'Free VS Code' sub  (aka not Azure production sub)

Pre-Req: 

Increase quota: A minimun of 44 vCPUs is needed
https://docs.openshift.com/container-platform/4.17/installing/installing_azure/installing-azure-account.html#installation-azure-increasing-limits_installing-azure-account

Check quota for region: 
LOCATION=eastus
az vm list-usage -l $LOCATION --query "[?contains(name.value, 'standardDSv3Family')]" -o table


