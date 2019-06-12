# Manditory Parameters

variable "name_prefix" {

  type = "string"

}

variable "environment" {

  type = "string"

}



variable "vnet_cidr" {

  type = "string"

}



# Optional Generic Parameters

variable "location" {

  type = "string"

  default = "East US"

}



# Optional Service Specific Parameters

variable "service_endpoints" {

  type = "list"

  default = [

    "Microsoft.AzureActiveDirectory",

    "Microsoft.AzureCosmosDB",

    "Microsoft.EventHub",

    "Microsoft.KeyVault",

    "Microsoft.ServiceBus",

    "Microsoft.Sql",

    "Microsoft.Storage"

  ]

}







##################################################

# Internal Lookup Variables (pending 0.12 release)

variable "environment_map" {

  type = "map"

  default = {

    "dev"         = "Development"

    "Dev"         = "Development"

    "development" = "Development"

    "stage"       = "Staging"

    "Stage"       = "Staging"

    "prod"        = "Production"

    "production"  = "Production"

    "Prod"        = "Production"

    "Sand"        = "Sandbox"

    "sandbox"     = "Sandbox"

    "sand"        = "Sandbox"

    "tst"         = "Sandbox"

    "test"        = "Sanbox"

  }

}
