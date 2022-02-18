module "nsg_rule" {
  source = "./nsg_rule"

  nsg_rules_table         = var.nsg_rule_table
  rg                      = azurerm_resource_group.example.name
  location                = azurerm_resource_group.example.location
  tags                    = {}
}


