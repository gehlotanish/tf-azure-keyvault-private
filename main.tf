resource "azurerm_key_vault" "main" {
  for_each                      = var.keyvaults
  name                          = each.value.name
  location                      = each.value.location
  resource_group_name           = var.resource_group_name
  tenant_id                     = data.azurerm_client_config.current.tenant_id
  sku_name                      = each.value.sku
  soft_delete_retention_days    = each.value.soft_delete_retention_days
  purge_protection_enabled      = each.value.purge_protection
  public_network_access_enabled = each.value.public_network_access_enabled
  enable_rbac_authorization     = each.value.enable_rbac_authorization

  # Default access policy (optional based on RBAC setting)
  dynamic "access_policy" {
    for_each = each.value.enable_rbac_authorization ? [] : [1]
    content {
      tenant_id = data.azurerm_client_config.current.tenant_id
      object_id = data.azurerm_client_config.current.object_id

      key_permissions         = each.value.key_permissions
      secret_permissions      = each.value.secret_permissions
      certificate_permissions = each.value.certificate_permissions
    }
  }

  # Network ACLs
  dynamic "network_acls" {
    for_each = each.value.network_acls != null ? [each.value.network_acls] : []
    content {
      bypass                     = network_acls.value.bypass
      default_action             = network_acls.value.default_action
      ip_rules                   = network_acls.value.ip_rules
      virtual_network_subnet_ids = network_acls.value.virtual_network_subnet_ids
    }
  }

  tags = merge(
    {
      "environment" = each.value.environment
      "managed_by"  = "terraform"
    },
    each.value.keyvault_extra_tags
  )
}

resource "azurerm_monitor_diagnostic_setting" "keyvault_diag" {
  for_each = {
    for k, v in azurerm_key_vault.main : k => v
    if var.keyvaults[k].diag_enabled && var.log_analytics_workspace_name != null
  }
  name                       = "${each.value.name}-diagnostics"
  target_resource_id         = each.value.id
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
  for_each = {
    for k, v in azurerm_key_vault.main : k => v
    if var.keyvaults[k].custom_role_enabled && var.keyvaults[k].custom_role_definition_id != "" && var.keyvaults[k].custom_role_principal_id != ""
  }
  scope                            = each.value.id
  role_definition_id               = var.keyvaults[each.key].custom_role_definition_id
  principal_id                     = var.keyvaults[each.key].custom_role_principal_id
  skip_service_principal_aad_check = true
}


resource "azurerm_private_endpoint" "keyvault" {
  for_each = {
    for k, v in var.keyvaults : k => v
    if v.private_endpoint != null && v.private_endpoint.enabled
  }
  name                = each.value.private_endpoint.network_interface_name != null ? each.value.private_endpoint.network_interface_name : "${each.value.name}-pe"
  location            = each.value.location
  resource_group_name = var.resource_group_name
  subnet_id           = each.value.private_endpoint.subnet_id

  private_service_connection {
    name                           = each.value.private_endpoint.private_connection_name != null ? each.value.private_endpoint.private_connection_name : "${each.value.name}-psc"
    private_connection_resource_id = azurerm_key_vault.main[each.key].id
    is_manual_connection           = each.value.private_endpoint.is_manual_connection
    subresource_names              = each.value.private_endpoint.subresource_names
    request_message                = each.value.private_endpoint.request_message
  }

  dynamic "private_dns_zone_group" {
    for_each = each.value.private_endpoint.private_dns_zone_id != null ? [1] : []
    content {
      name                 = "${each.value.name}-dns-zone-group"
      private_dns_zone_ids = [each.value.private_endpoint.private_dns_zone_id]
    }
  }

  tags = merge(
    {
      "environment" = each.value.environment
      "managed_by"  = "terraform"
    },
    each.value.keyvault_extra_tags
  )
}