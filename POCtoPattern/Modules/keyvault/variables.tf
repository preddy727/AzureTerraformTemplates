# Manditory Parameters

variable "ip_rules" {
  type    = "list"
}

variable "objectid" {

  type = "string"

}


variable "objectid2" {

  type = "string"

}
variable "applicationid" {

  type = "string"

}

variable "name_prefix" {

  type = "string"

}

variable "environment" {

  type = "string"

}

# Optional Generic Parameters

variable "location" {

  type = "string"

  default = "East US"

}






# Optional Service Specific Parameters

variable "key_opts" {

  type = "list"

  default = ["decrypt", "encrypt", "sign", "unwrapKey", "verify", "wrapKey"]

}



variable "key_permissions" {

  type = "list"

  default = ["backup", 

    "create", 

    "decrypt", 

    "delete", 

    "encrypt", 

    "get", 

    "import", 

    "list", 

    "purge", 

    "recover", 

    "restore", 

    "sign", 

    "unwrapKey", 

    "update", 

    "verify", 

    "wrapKey"

  ]

}



variable "secret_permissions" {

  type = "list"

  default = ["backup", "delete", "get", "list", "purge", "recover", "restore", "set"]

}



variable "vault_sku" {

  type = "string"

  default = "standard"

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
