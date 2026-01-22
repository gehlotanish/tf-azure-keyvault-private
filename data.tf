data "azurerm_log_analytics_workspace" "existing" {
  count               = var.log_analytics_workspace_name != null ? 1 : 0
  name                = var.log_analytics_workspace_name
  resource_group_name = var.log_analytics_resource_group_name
}

data "azurerm_client_config" "current" {}
