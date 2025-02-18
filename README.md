# aro
ARO install script in 'Free VS Code' sub  (aka not Azure production sub)

## Pre-Req: 

1. Increase quota: A minimun of 44 vCPUs is needed and the default is only 30.  Read the instructions on [increasing-limits](https://docs.openshift.com/container-platform/4.17/installing/installing_azure/installing-azure-account.html#installation-azure-increasing-limits_installing-azure-account) via portal.  
 
2. Check quota for region: 
    $ LOCATION=eastus
    $ az vm list-usage -l $LOCATION --query "[?contains(name.value, 'standardDSv3Family')]" -o table

3. Register resource providers
    $ az provider register --namespace Microsoft.Kubernetes --wait
    $ az provider register --namespace Microsoft.KubernetesConfiguration --wait
    $ az provider register --namespace Microsoft.ExtendedLocation --wait
    $ az provider register --namespace Microsoft.RedHatOpenShift --wait

5. Check that the providers are registered 
    $ az provider show -n Microsoft.Kubernetes -o table
    $ az provider show -n Microsoft.KubernetesConfiguration -o table
    $ az provider show -n Microsoft.ExtendedLocation -o table
    $ az provider show -n Microsoft.RedHatOpenShift -o table
