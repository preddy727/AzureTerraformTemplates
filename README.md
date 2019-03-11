1)	Create a key vault enabled for Azure disk encryption,  access policy, key permissions, secret permissions, network acls, tags.  
2)	Create a VM with a managed identity and granted access to key vault to create a key.  Assign managed identity with contributor role to subscription. 
3)	Create a managed image and store it in shared image gallery
4)	Create a VM and Scaleset using shared image gallery image.  Enable virtual network service endpoint.  
5)	Enable disk encryption on running vms 

