variable "resource_group_name" {}
variable "location" {}

variable "networking_object" {}

variable "pip" {}

variable "admin_username" {
  default = "azureuser"
}

variable "admin_password" {}
variable "custom_data" {}

variable "mysqlvm" {}
variable "webserver" {}

variable "nsg_rule_table" {}
