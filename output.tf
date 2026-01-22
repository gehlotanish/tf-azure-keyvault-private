output "key_vault_id" {
  value       = { for k, v in azurerm_key_vault.main : k => v.id }
  description = "Map of Key Vault names to their IDs."
}

output "key_vault_uri" {
  value       = { for k, v in azurerm_key_vault.main : k => v.vault_uri }
  description = "Map of Key Vault names to their URIs, used for accessing secrets, keys, and certificates."
}

output "key_vault_name" {
  value       = { for k, v in azurerm_key_vault.main : k => v.name }
  description = "Map of Key Vault names to their names."
}

output "diagnostic_setting_id" {
  value       = { for k, v in azurerm_monitor_diagnostic_setting.keyvault_diag : k => v.id }
  description = "Map of Key Vault keys to their diagnostic setting IDs, if enabled. Returns empty map if diagnostics are not configured."
}

output "log_analytics_workspace_id" {
  value       = var.log_analytics_workspace_name != null ? data.azurerm_log_analytics_workspace.existing[0].id : null
  description = "The ID of the Log Analytics Workspace used for diagnostics, if configured. Returns null if no workspace is specified."
}

output "private_endpoint_id" {
  value       = { for k, v in azurerm_private_endpoint.keyvault : k => v.id }
  description = "Map of Key Vault keys to their private endpoint IDs, if enabled. Returns empty map if private endpoints are not configured."
}

output "private_endpoint_network_interface_id" {
  value       = { for k, v in azurerm_private_endpoint.keyvault : k => v.network_interface_ids[0] }
  description = "Map of Key Vault keys to their private endpoint network interface IDs, if enabled. Returns empty map if private endpoints are not configured."
}

output "private_endpoint_private_ip_address" {
  value       = { for k, v in azurerm_private_endpoint.keyvault : k => v.private_ip_address }
  description = "Map of Key Vault keys to their private endpoint private IP addresses, if enabled. Returns empty map if private endpoints are not configured."
}