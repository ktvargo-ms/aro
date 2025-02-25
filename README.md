# ARO - Azure RedHat OpenShift 

## ARO install script in 'Free VS Code' sub  (aka not Azure production sub)

### Pre-Req: 

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

It is recommended to use a SP with proper permissions. [Creating Azure SP](https://docs.openshift.com/container-platform/4.17/installing/installing_azure/installing-azure-account.html#installation-creating-azure-service-principal_installing-azure-account) gives more details on proper permissions. 

Note: MS tenants wil require a SP tied to proper ServiceTree. 


### Notes: 

1. The cluster is expensive to run and will use up your balance in a couple days.  There is no 'Stop' option, only delete.
2. [Connect to the OpenShift Console](https://learn.microsoft.com/en-us/azure/openshift/connect-cluster) after the cluster is created. 
   
## ARM Template 

### Notes:

1. The ARM template requires a SP tied to Service Tree with the following permissions:
contributor and user access admin roles
[Creating Azure SP](https://docs.openshift.com/container-platform/4.17/installing/installing_azure/installing-azure-account.html#installation-creating-azure-service-principal_installing-azure-account) gives more details on proper permissions.

2. RedHat Provider ID:
```bash
az ad sp list --filter "displayname eq 'Azure Red Hat OpenShift RP'" --query "[?appDisplayName=='Azure Red Hat OpenShift RP'].{name: appDisplayName, objectId: id}"
```

3. Check quota for region:
```bash
    LOCATION=eastus
    az vm list-usage -l $LOCATION --query "[?contains(name.value, 'standardDSv3Family')]" -o table
```

4. Register resource providers
```bash
    az provider register --namespace Microsoft.Kubernetes --wait
    az provider register --namespace Microsoft.KubernetesConfiguration --wait
    az provider register --namespace Microsoft.ExtendedLocation --wait
    az provider register --namespace Microsoft.RedHatOpenShift --wait
```

5. Check that the providers are registered 
```bash
    az provider show -n Microsoft.Kubernetes -o table
    az provider show -n Microsoft.KubernetesConfiguration -o table
    az provider show -n Microsoft.ExtendedLocation -o table
    az provider show -n Microsoft.RedHatOpenShift -o table
```
6. Optional: Obtain a Red Hat pull secret 
   
A Red Hat pull secret enables your cluster to access Red Hat container registries along with additional content. This step is optional but recommended. Without the pull secret, you will have limited functionality.

OpenShift Login Procedure:
- Log in to the [OpenShift® cluster manager portal](https://www.ibm.com/links?url=https%3A%2F%2Fconsole.redhat.com%2Fopenshift%2Finstall%2Fazure%2Faro-provisioned).
- Click Download pull secret to download the pull secret (it is encouraged that you store the file in a safe location).
- Save the file as pull-secret.txt and place it in the same location as the install script.

### Open Issues: 
1. Cluster deployment fails with 'Internal Server Error'.  Current issues:
   - NSGs are added automatically to VNets.  Use azuredeploynetwork.json to deploy only the network, wait for NSGs to be added, and modify NSG. 
   - Try --bring-own-nsg as option on cluster build. [Bring Your Own NSG](https://learn.microsoft.com/en-us/azure/openshift/howto-bring-nsg) instructions.
   - azuredeploy.json includes network build with new or existing option, so you can run this after vnet is setup correctly. It does not include --bring-your-own-nsg option. 
     
   

### Connecting to Built Cluster
 [Connect to the OpenShift Console](https://learn.microsoft.com/en-us/azure/openshift/connect-cluster) after the cluster is created. 


