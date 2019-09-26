data "azurerm_resource_group" "pls_forwarder" {
  name = var.pls_forwarder_resource_group_name
}

data "azurerm_resource_group" "pe" {
  name = var.pe_resource_group_name
}

data "azurerm_resource_group" "pls_vnet_rg" {
  name = var.pls_vnet_resource_group_name
}

data "azurerm_subnet" "proxy_subnet" {
  name                 = var.proxy_subnet_name
  virtual_network_name = var.virtual_network_name
  resource_group_name  = var.pls_vnet_resource_group_name
}

data "azurerm_subnet" "pls_subnet" {
  name                 = var.pls_subnet_name
  virtual_network_name = var.virtual_network_name
  resource_group_name  = var.pls_vnet_resource_group_name
}

module "loadbalancer" {
  source              = "github.com/preddy727/terraform-azurerm-loadbalancer"
  resource_group_name = var.pls_forwarder_resource_group_name
  location            = var.location
  prefix              = "terraform-test"
  frontend_subnet_id  = data.azurerm_subnet.proxy_subnet.id
  remote_port = {
    sql = ["Tcp", "1433"]
  }
  lb_port = {
    sql = ["1433", "Tcp", "1433"]
  }
}

data "template_file" "cloudinit" {
  template = file("${path.module}/cloudconfig.tpl")
  vars = {
    sql_mi_fqdn = var.sql_mi_fqdn
  }
}

module "vmss-cloudinit" {
  source                                 = "github.com/preddy727/terraform-azurerm-vmss-cloudinit"
  network_profile                        = var.network_profile
  resource_group_name                    = var.pls_forwarder_resource_group_name
  custom_data                            = data.template_file.cloudinit.rendered
  location                               = var.location
  vm_size                                = var.vm_size
  admin_username                         = "azureuser"
  admin_password                         = "AzurePassword123456!"
  ssh_key                                = "~/.ssh/id_rsa.pub"
  nb_instance                            = var.nb_instance
  vm_os_simple                           = var.vm_os_simple
  vnet_subnet_id                         = data.azurerm_subnet.proxy_subnet.id
  load_balancer_backend_address_pool_ids = module.loadbalancer.azurerm_lb_backend_address_pool_id
}

resource "azurerm_private_link_service" "pls" {
  name                = var.pl_service
  location            = data.azurerm_resource_group.pls_forwarder.location
  resource_group_name = data.azurerm_resource_group.pls_forwarder.name

  ip_configuration {
    name               = "pls_nat"
    subnet_id          = data.azurerm_subnet.pls_subnet.id
    private_ip_address = var.pl_service_pvt_ip
  }

  load_balancer_frontend_ip_configuration {
    id = module.loadbalancer.azurerm_lb_frontend_ip_configuration[0].id
  } 
}
