resource_group_name="deleteme-mysql-demo"
location="koreacentral"

networking_object                 = {
  vnet = {
      name                = "-vnet"
      address_space       = ["10.10.0.0/16"]
      dns                 = []
  }
  specialsubnets = {
  }

  subnets = {
    subnet-frontend   = {
      name                = "subnet-frontend"
      cidr                = "10.10.0.0/24"
      service_endpoints   = []
      nsg_name            = "nsg-frontend"
    }
 
    subnet-backend   = {
      name                = "subnet-backend"
      cidr                = "10.10.1.0/24"
      service_endpoints   = []
      nsg_name            = "nsg-backend"
    }
 
  }
}

custom_data = "cloud_init.txt"

pip = {
  0               = {
    name          = "pip-webserver"
  }
}

webserver = {
  name          = "webserver"

  vm_num        = 1
  vm_size       = "Standard_D8s_v3"
    
  subnet        = "subnet-frontend"
  subnet_ip_offset  = 4
  
  vm_publisher      = "Canonical"
  vm_offer          = "0001-com-ubuntu-server-focal"
  vm_sku            = "20_04-LTS"
  vm_version        = "latest" 
}


mysqlvm = {
  name          = "mysqlvm"

  vm_num        = 1
  vm_size       = "Standard_D8s_v3"
    
  subnet        = "subnet-backend"
  subnet_ip_offset  = 4
  
  vm_publisher      = "Canonical"
  vm_offer          = "0001-com-ubuntu-server-focal"
  vm_sku            = "20_04-LTS"
  vm_version        = "latest" 
}

admin_username="azureuser"
admin_password="enterpasswordhere"
