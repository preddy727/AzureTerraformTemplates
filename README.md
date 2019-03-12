# Infrastructure as Code on Azure
## Overview

Deploying a sample Tomcat Application on Azure using Packer to create an image and Terraform to deply a Virtual Machine Scale Set

## Pre-requisites 
* Create a Terraform Linux virtual machine with managed identities [here](https://docs.microsoft.com/en-us/azure/terraform/terraform-vm-msi)
* Install the Packer precompiled binary on the Terraform VM [download](https://www.packer.io/intro/getting-started/install.html#precompiled-binaries)

## Recommended Reading
* Series of Labs for Terraform on Azure [here](https://azurecitadel.com/automation/terraform/)

### Architecture Diagram
* Process flow [![alt text](https://github.com/preddy727/AzureTerraformTemplates/blob/master/images/Picture1.png)]

## Goals of the Lab
1. Create a customized Ubuntu managed image with Tomcat installed 
2. Create a Key Vault enabled for disk encryption and a Key
3. Deploy a Virtual machine scale set
    * Enable service endpoint for Key Vault. 
    * Update key vault access policy to allow scale set subnet. 
    * Enable disk encryption extension and associate with key
4. Access Tomcat webpage 

## Exercises

* [Create a customized Ubuntu managed image with Tomcat installed](#Custom-Ubuntu-Tomcat-with-Packer)
* [Create a Key Vault enabled for disk encryption and a Key](#create-the-key-vault-disk-encryption-with-key)
* [Deploy a Virtual machine scale set](#deploy-a-vmss)
* [Access Tomcat webpage](#Access-the-tomcat-webpage)


## Custom Ubuntu Tomcat with Packer
### [Back to Excercises](#exercises)

1. 

2. 


## Create the key vault disk encryption with key
### [Back to Excercises](#exercises)

## Deploy a Virtual machine scale set
### [Back to Excercises](#exercises)

## Access Tomcat webpage
### [Back to Excercises](#exercises)
