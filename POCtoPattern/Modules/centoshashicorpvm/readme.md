#Usage
var.admin_password
  The Password for the account specified in the 'admin_username' field. We recommend disabling Password Authentication in a Production environment.

  Enter a value: Attdemo123!

var.environment
  Enter a value: dev

var.hostname
  VM name referenced also in storage-related names. This is also used as the label for the Domain Name and to make up the FQDN. If a domain name label is specified, an A DNS record is created for the public IP in the Microsoft Azure DNS system.

  Enter a value: iacicdvm1

var.name_prefix
  Enter a value: iaccicd6

var.storageaccountname
  Enter a value: test

var.vnet_cidr
  Enter a value: 10.0.0.0/25