resource "azurerm_key_vault" "main" {
  name                          = var.keyvault_name
  location                      = var.location
  resource_group_name           = var.resource_group_name
  tenant_id                     = data.azurerm_client_config.current.tenant_id
  sku_name                      = var.sku_name
  soft_delete_retention_days    = var.soft_delete_retention_days
  purge_protection_enabled      = var.purge_protection
  public_network_access_enabled = var.public_network_access_enabled
  enable_rbac_authorization     = var.enable_rbac_authorization

  # Default access policy (optional based on RBAC setting)
  dynamic "access_policy" {
    for_each = var.enable_rbac_authorization ? [] : [1]
    content {
      tenant_id = data.azurerm_client_config.current.tenant_id
      object_id = data.azurerm_client_config.current.object_id

      key_permissions         = var.key_permissions
      secret_permissions      = var.secret_permissions
      certificate_permissions = var.certificate_permissions
    }
  }

  # Network ACLs
  dynamic "network_acls" {
    for_each = var.network_acls != null ? [var.network_acls] : []
    content {
      bypass                     = network_acls.value.bypass
      default_action             = network_acls.value.default_action
      ip_rules                   = network_acls.value.ip_rules
      virtual_network_subnet_ids = network_acls.value.virtual_network_subnet_ids
    }
  }

  tags = merge(
    {
      "environment" = var.environment
      "managed_by"  = "terraform"
    },
    var.keyvault_extra_tags
  )
}

resource "azurerm_monitor_diagnostic_setting" "keyvault_diag" {
  count                      = var.diag_enabled && var.log_analytics_workspace_name != null ? 1 : 0
  name                       = "${var.keyvault_name}-diagnostics"
  target_resource_id         = azurerm_key_vault.main.id
  log_analytics_workspace_id = data.azurerm_log_analytics_workspace.existing[0].id

  # Audit Logs
  enabled_log {
    category = "AuditEvent"
  }

  # Metrics
  metric {
    category = "AllMetrics"
    enabled  = true
  }
}

resource "azurerm_role_assignment" "keyvault_custom_role" {
  count                            = var.custom_role_enabled ? 1 : 0
  scope                            = azurerm_key_vault.main.id
  role_definition_id               = var.custom_role_definition_id
  principal_id                     = var.custom_role_principal_id
  skip_service_principal_aad_check = true
}