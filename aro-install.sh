#!/bin/bash

set -x
#Get Account Infomration and Alias:

EngAlias=$(az account show --query user.name -o tsv | cut -d'@' -f1)

ARODATE=$(date -u +%F)

AROTIME=$(date -u +"%T" | sed 's/:/-/g')

AROQueryTime=$(date -u +"%FT%TZ")

#Define Envrinoment Variables :

LOCATION=westus3 # Location of your ARO cluster

AROCluster="aro-$ARODATE-pub" # Name of the ARO Cluster

ARORG="$AROCluster-rg" # Name of Resource Group where you want to create your ARO Cluster

VNETName="$AROCluster-vnet" # Name of ARO VNET

VNETAddr="10.0.0.0/22" # VNET Address Prefixes

MasterSubNet="$AROCluster-master-subnet" # Name of ARO Master Subnet

MasterAddr="10.0.2.0/24" # Master Subnet Address Prefixes

WorkerSubNet="$AROCluster-worker-subnet" # Name of ARO Worker Subnet

WorkerAddr="10.0.3.0/24" # Worker Subnet Address Prefixes

ARONodeRG="$AROCluster-mc-rg"

#Create ARO Cluster Prerequisites :

az group create --name $ARORG --location $LOCATION

az network vnet create --resource-group $ARORG --name $VNETName --address-prefixes $VNETAddr

az network vnet subnet create --resource-group $ARORG --vnet-name $VNETName --name $MasterSubNet --address-prefixes $MasterAddr --service-endpoints Microsoft.ContainerRegistry

az network vnet subnet create --resource-group $ARORG --vnet-name $VNETName --name $WorkerSubNet --address-prefixes $WorkerAddr --service-endpoints Microsoft.ContainerRegistry

az network vnet subnet update --name $MasterSubNet --resource-group $ARORG --vnet-name $VNETName --disable-private-link-service-network-policies true

#Create ARO Cluster without Predefined SP :

az aro create --resource-group $ARORG --name $AROCluster --vnet $VNETName --master-subnet $MasterSubNet --worker-subnet $WorkerSubNet --pull-secret @pull-secret.txt --cluster-resource-group $ARONodeRG --debug
