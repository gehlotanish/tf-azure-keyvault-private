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
| <a name="input_certificate_permissions"></a> [certificate\_permissions](#input\_certificate\_permissions) | List of certificate permissions for the access policy (if RBAC is not enabled). Valid values include 'Get', 'List', 'Create', 'Delete', 'Update', etc. | `list(string)` | <pre>[<br/>  "Get",<br/>  "List"<br/>]</pre> | no |
| <a name="input_custom_role_definition_id"></a> [custom\_role\_definition\_id](#input\_custom\_role\_definition\_id) | The ID of the custom role definition | `string` | `""` | no |
| <a name="input_custom_role_enabled"></a> [custom\_role\_enabled](#input\_custom\_role\_enabled) | Set to true to enable custom role assignment to Key Vault | `bool` | `true` | no |
| <a name="input_custom_role_principal_id"></a> [custom\_role\_principal\_id](#input\_custom\_role\_principal\_id) | The object ID of the principal (user/group/service principal) to assign the role to | `string` | `""` | no |
| <a name="input_diag_enabled"></a> [diag\_enabled](#input\_diag\_enabled) | Enables diagnostic settings for the Key Vault, sending logs and metrics to the specified Log Analytics Workspace. Set to 'true' to enable. | `bool` | `false` | no |
| <a name="input_enable_rbac_authorization"></a> [enable\_rbac\_authorization](#input\_enable\_rbac\_authorization) | Enables Azure Role-Based Access Control (RBAC) for the Key Vault instead of using access policies. Set to 'true' to use RBAC. | `bool` | `false` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | The environment tag for the Key Vault (e.g., 'production', 'staging', 'development') used for resource tagging. | `string` | `"production"` | no |
| <a name="input_key_permissions"></a> [key\_permissions](#input\_key\_permissions) | List of key permissions for the access policy (if RBAC is not enabled). Valid values include 'Create', 'Get', 'List', 'Delete', etc. | `list(string)` | <pre>[<br/>  "Create",<br/>  "Get"<br/>]</pre> | no |
| <a name="input_keyvault_extra_tags"></a> [keyvault\_extra\_tags](#input\_keyvault\_extra\_tags) | A map of additional tags to apply to the Key Vault beyond the default tags (environment and managed\_by). | `map(string)` | `{}` | no |
| <a name="input_keyvault_name"></a> [keyvault\_name](#input\_keyvault\_name) | The name of the Azure Key Vault. Must be globally unique, 3-24 characters long, and can only contain alphanumeric characters and hyphens. | `string` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | The Azure region where the Key Vault and related resources will be deployed (e.g., 'eastus', 'westeurope'). | `string` | n/a | yes |
| <a name="input_log_analytics_resource_group_name"></a> [log\_analytics\_resource\_group\_name](#input\_log\_analytics\_resource\_group\_name) | The name of the Azure Resource Group containing the existing Log Analytics Workspace used for diagnostic settings. | `string` | n/a | yes |
| <a name="input_log_analytics_workspace_name"></a> [log\_analytics\_workspace\_name](#input\_log\_analytics\_workspace\_name) | The name of an existing Log Analytics Workspace to use for diagnostic settings. If null and diag\_enabled is true, diagnostics will not be configured. | `string` | `null` | no |
| <a name="input_network_acls"></a> [network\_acls](#input\_network\_acls) | Network ACL configuration for the Key Vault. Includes bypass (e.g., 'AzureServices'), default\_action ('Allow' or 'Deny'), ip\_rules (list of CIDR ranges), and virtual\_network\_subnet\_ids (list of subnet IDs). Set to null to disable network ACLs. | <pre>object({<br/>    bypass                     = string<br/>    default_action             = string<br/>    ip_rules                   = list(string)<br/>    virtual_network_subnet_ids = list(string)<br/>  })</pre> | `null` | no |
| <a name="input_public_network_access_enabled"></a> [public\_network\_access\_enabled](#input\_public\_network\_access\_enabled) | Controls whether the Key Vault is accessible from public networks. Set to 'false' to restrict access to private networks only. | `bool` | `true` | no |
| <a name="input_purge_protection"></a> [purge\_protection](#input\_purge\_protection) | Enables purge protection for the Key Vault, preventing permanent deletion of the vault and its contents even after soft delete. Set to 'true' to enable. | `bool` | `false` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The name of the Azure Resource Group where the Key Vault will be created. | `string` | n/a | yes |
| <a name="input_secret_permissions"></a> [secret\_permissions](#input\_secret\_permissions) | List of secret permissions for the access policy (if RBAC is not enabled). Valid values include 'Set', 'Get', 'List', 'Delete', 'Purge', 'Recover', etc. | `list(string)` | <pre>[<br/>  "Set",<br/>  "Get",<br/>  "Delete",<br/>  "Purge",<br/>  "Recover"<br/>]</pre> | no |
| <a name="input_sku_name"></a> [sku\_name](#input\_sku\_name) | The SKU name for the Key Vault. Valid values are 'standard' or 'premium'. 'premium' includes support for HSM-backed keys. | `string` | `"standard"` | no |
| <a name="input_soft_delete_retention_days"></a> [soft\_delete\_retention\_days](#input\_soft\_delete\_retention\_days) | The number of days that deleted Key Vault items (keys, secrets, certificates) are retained before permanent deletion. Must be between 7 and 90. | `number` | `90` | no |  
## Outputs

| Name | Description |
|------|-------------|
| <a name="output_diagnostic_setting_id"></a> [diagnostic\_setting\_id](#output\_diagnostic\_setting\_id) | The ID of the diagnostic setting for the Key Vault, if enabled. Returns null if diagnostics are not configured. |
| <a name="output_key_vault_id"></a> [key\_vault\_id](#output\_key\_vault\_id) | The ID of the created Azure Key Vault. |
| <a name="output_key_vault_name"></a> [key\_vault\_name](#output\_key\_vault\_name) | The name of the created Azure Key Vault. |
| <a name="output_key_vault_uri"></a> [key\_vault\_uri](#output\_key\_vault\_uri) | The URI of the created Azure Key Vault, used for accessing secrets, keys, and certificates. |
| <a name="output_log_analytics_workspace_id"></a> [log\_analytics\_workspace\_id](#output\_log\_analytics\_workspace\_id) | The ID of the Log Analytics Workspace used for diagnostics, if configured. Returns null if diagnostics are not enabled or no workspace is specified. |
<!-- END_TF_DOCS -->

## Usage

```yaml

module "log_analytics" {
  source =  <>

# Key Vault configuration
keyvault_name               = "mykeyvault123"
location                    = "eastus"
resource_group_name         = "my-resource-group"
log_analytics_resource_group_name = "my-monitoring-group"

# Key Vault properties
sku_name                    = "standard"
soft_delete_retention_days  = 90
purge_protection            = false
public_network_access_enabled = true
enable_rbac_authorization   = false
environment                 = "production"

# Diagnostic settings
diag_enabled                      = true
log_analytics_workspace_name      = "my-log-analytics-workspace"
log_analytics_resource_group_name = "my-log-analytics-workspace-rg"

# Additional tags
keyvault_extra_tags = {
  "project"     = "my-project"
  "owner"       = "team@example.com"
}

# Network ACLs (optional)
network_acls = {
  bypass                     = "AzureServices"
  default_action             = "Deny"
  ip_rules                   = ["203.0.113.0/24"]
  virtual_network_subnet_ids = ["/subscriptions/12345678-1234-1234-1234-1234567890ab/resourceGroups/my-resource-group/providers/Microsoft.Network/virtualNetworks/my-vnet/subnets/my-subnet"]
}

# Access policy permissions (used if enable_rbac_authorization is false)
key_permissions = [
  "Create",
  "Get",
  "List",
  "Delete"
 ]

secret_permissions = [
  "Set",
  "Get",
  "Delete",
  "Purge",
  "Recover"
 ]

certificate_permissions = [
  "Get",
  "List",
  "Create",
  "Update"
 ]
}

```
