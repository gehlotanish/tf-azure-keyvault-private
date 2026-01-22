# terraform code for Azure log analytics workspace

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.5 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 4.25.0 |
## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 4.25.0 |
## Modules

No modules.
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_keyvaults"></a> [keyvaults](#input\_keyvaults) | Map of Key Vault configurations. Each Key Vault must have a unique name (globally unique, 3-24 characters, alphanumeric and hyphens only) and location. All other parameters are optional with defaults. | <pre>map(object({<br/>    name                          = string<br/>    location                      = string<br/>    sku                           = optional(string, "standard")<br/>    soft_delete_retention_days    = optional(number, 90)<br/>    purge_protection              = optional(bool, false)<br/>    public_network_access_enabled = optional(bool, true)<br/>    enable_rbac_authorization     = optional(bool, false)<br/>    environment                   = optional(string, "production")<br/>    keyvault_extra_tags           = optional(map(string), {})<br/>    network_acls = optional(object({<br/>      bypass                     = string<br/>      default_action             = string<br/>      ip_rules                   = list(string)<br/>      virtual_network_subnet_ids = list(string)<br/>    }), null)<br/>    key_permissions           = optional(list(string), ["Create", "Get"])<br/>    secret_permissions        = optional(list(string), ["Set", "Get", "Delete", "Purge", "Recover"])<br/>    certificate_permissions   = optional(list(string), ["Get", "List"])<br/>    diag_enabled              = optional(bool, false)<br/>    custom_role_enabled       = optional(bool, true)<br/>    custom_role_definition_id = optional(string, "")<br/>    custom_role_principal_id  = optional(string, "")<br/>    private_endpoint = optional(object({<br/>      enabled                 = bool<br/>      subnet_id               = string<br/>      private_dns_zone_id     = optional(string, null)<br/>      private_connection_name = optional(string, null)<br/>      network_interface_name  = optional(string, null)<br/>      request_message         = optional(string, "Auto-Approved")<br/>      subresource_names       = optional(list(string), ["vault"])<br/>      is_manual_connection    = optional(bool, false)<br/>    }), null)<br/>  }))</pre> | n/a | yes |
| <a name="input_log_analytics_resource_group_name"></a> [log\_analytics\_resource\_group\_name](#input\_log\_analytics\_resource\_group\_name) | The name of the Azure Resource Group containing the existing Log Analytics Workspace used for diagnostic settings. | `string` | n/a | yes |
| <a name="input_log_analytics_workspace_name"></a> [log\_analytics\_workspace\_name](#input\_log\_analytics\_workspace\_name) | The name of an existing Log Analytics Workspace to use for diagnostic settings. If null, diagnostics will not be configured even if diag\_enabled is true for a Key Vault. | `string` | `null` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The name of the Azure Resource Group where the Key Vault will be created. | `string` | n/a | yes |  
## Outputs

| Name | Description |
|------|-------------|
| <a name="output_diagnostic_setting_id"></a> [diagnostic\_setting\_id](#output\_diagnostic\_setting\_id) | Map of Key Vault keys to their diagnostic setting IDs, if enabled. Returns empty map if diagnostics are not configured. |
| <a name="output_key_vault_id"></a> [key\_vault\_id](#output\_key\_vault\_id) | Map of Key Vault names to their IDs. |
| <a name="output_key_vault_name"></a> [key\_vault\_name](#output\_key\_vault\_name) | Map of Key Vault names to their names. |
| <a name="output_key_vault_uri"></a> [key\_vault\_uri](#output\_key\_vault\_uri) | Map of Key Vault names to their URIs, used for accessing secrets, keys, and certificates. |
| <a name="output_log_analytics_workspace_id"></a> [log\_analytics\_workspace\_id](#output\_log\_analytics\_workspace\_id) | The ID of the Log Analytics Workspace used for diagnostics, if configured. Returns null if no workspace is specified. |
| <a name="output_private_endpoint_id"></a> [private\_endpoint\_id](#output\_private\_endpoint\_id) | Map of Key Vault keys to their private endpoint IDs, if enabled. Returns empty map if private endpoints are not configured. |
| <a name="output_private_endpoint_network_interface_id"></a> [private\_endpoint\_network\_interface\_id](#output\_private\_endpoint\_network\_interface\_id) | Map of Key Vault keys to their private endpoint network interface IDs, if enabled. Returns empty map if private endpoints are not configured. |
| <a name="output_private_endpoint_private_ip_address"></a> [private\_endpoint\_private\_ip\_address](#output\_private\_endpoint\_private\_ip\_address) | Map of Key Vault keys to their private endpoint private IP addresses, if enabled. Returns empty map if private endpoints are not configured. |
<!-- END_TF_DOCS -->
