# aro
ARO install script in 'Free VS Code' sub  (aka not Azure production sub)

## Pre-Req: 

1. Increase quota:
  
A minimun of 44 vCPUs is needed and the default is only 30.  Read the instructions on [increasing-limits](https://docs.openshift.com/container-platform/4.17/installing/installing_azure/installing-azure-account.html#installation-azure-increasing-limits_installing-azure-account) via portal.  
 
2. Check quota for region:
```bash
    LOCATION=eastus
    az vm list-usage -l $LOCATION --query "[?contains(name.value, 'standardDSv3Family')]" -o table
```

3. Register resource providers
```bash
    az provider register --namespace Microsoft.Kubernetes --wait
    az provider register --namespace Microsoft.KubernetesConfiguration --wait
    az provider register --namespace Microsoft.ExtendedLocation --wait
    az provider register --namespace Microsoft.RedHatOpenShift --wait
```

4. Check that the providers are registered 
```bash
    az provider show -n Microsoft.Kubernetes -o table
    az provider show -n Microsoft.KubernetesConfiguration -o table
    az provider show -n Microsoft.ExtendedLocation -o table
    az provider show -n Microsoft.RedHatOpenShift -o table
```
5. Optional: Obtain a Red Hat pull secret 
   
A Red Hat pull secret enables your cluster to access Red Hat container registries along with additional content. This step is optional but recommended. Without the pull secret, you will have limited functionality.

Procedure:
- Log in to the [OpenShift® cluster manager portal](https://www.ibm.com/links?url=https%3A%2F%2Fconsole.redhat.com%2Fopenshift%2Finstall%2Fazure%2Faro-provisioned).
- Click Download pull secret to download the pull secret (it is encouraged that you store the file in a safe location).
- Save the file as pull-secret.txt and place it in the same location as the install script.

6. Optional: Create Service Princpal (SP) or Managed Identity.

It is recommended to use a SP with proper permissions. [Creating Azure SP](https://docs.openshift.com/container-platform/4.17/installing/installing_azure/installing-azure-account.html#installation-creating-azure-service-principal_installing-azure-account)
   
