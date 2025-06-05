variable "keyvault_name" {
  type        = string
  description = "The name of the Azure Key Vault. Must be globally unique, 3-24 characters long, and can only contain alphanumeric characters and hyphens."
}

variable "location" {
  type        = string
  description = "The Azure region where the Key Vault and related resources will be deployed (e.g., 'eastus', 'westeurope')."
}

variable "resource_group_name" {
  type        = string
  description = "The name of the Azure Resource Group where the Key Vault will be created."
}

variable "log_analytics_resource_group_name" {
  type        = string
  description = "The name of the Azure Resource Group containing the existing Log Analytics Workspace used for diagnostic settings."
}

variable "sku_name" {
  type        = string
  default     = "standard"
  description = "The SKU name for the Key Vault. Valid values are 'standard' or 'premium'. 'premium' includes support for HSM-backed keys."
}

variable "soft_delete_retention_days" {
  type        = number
  default     = 90
  description = "The number of days that deleted Key Vault items (keys, secrets, certificates) are retained before permanent deletion. Must be between 7 and 90."
}

variable "purge_protection" {
  type        = bool
  default     = false
  description = "Enables purge protection for the Key Vault, preventing permanent deletion of the vault and its contents even after soft delete. Set to 'true' to enable."
}

variable "public_network_access_enabled" {
  type        = bool
  default     = true
  description = "Controls whether the Key Vault is accessible from public networks. Set to 'false' to restrict access to private networks only."
}

variable "enable_rbac_authorization" {
  type        = bool
  default     = false
  description = "Enables Azure Role-Based Access Control (RBAC) for the Key Vault instead of using access policies. Set to 'true' to use RBAC."
}

variable "environment" {
  type        = string
  default     = "production"
  description = "The environment tag for the Key Vault (e.g., 'production', 'staging', 'development') used for resource tagging."
}

variable "diag_enabled" {
  type        = bool
  default     = false
  description = "Enables diagnostic settings for the Key Vault, sending logs and metrics to the specified Log Analytics Workspace. Set to 'true' to enable."
}

variable "log_analytics_workspace_name" {
  type        = string
  default     = null
  description = "The name of an existing Log Analytics Workspace to use for diagnostic settings. If null and diag_enabled is true, diagnostics will not be configured."
}

variable "keyvault_extra_tags" {
  type        = map(string)
  default     = {}
  description = "A map of additional tags to apply to the Key Vault beyond the default tags (environment and managed_by)."
}

variable "network_acls" {
  type = object({
    bypass                     = string
    default_action             = string
    ip_rules                   = list(string)
    virtual_network_subnet_ids = list(string)
  })
  default     = null
  description = "Network ACL configuration for the Key Vault. Includes bypass (e.g., 'AzureServices'), default_action ('Allow' or 'Deny'), ip_rules (list of CIDR ranges), and virtual_network_subnet_ids (list of subnet IDs). Set to null to disable network ACLs."
}

variable "key_permissions" {
  type        = list(string)
  default     = ["Create", "Get"]
  description = "List of key permissions for the access policy (if RBAC is not enabled). Valid values include 'Create', 'Get', 'List', 'Delete', etc."
}

variable "secret_permissions" {
  type        = list(string)
  default     = ["Set", "Get", "Delete", "Purge", "Recover"]
  description = "List of secret permissions for the access policy (if RBAC is not enabled). Valid values include 'Set', 'Get', 'List', 'Delete', 'Purge', 'Recover', etc."
}

variable "certificate_permissions" {
  type        = list(string)
  default     = ["Get", "List"]
  description = "List of certificate permissions for the access policy (if RBAC is not enabled). Valid values include 'Get', 'List', 'Create', 'Delete', 'Update', etc."
}

###
variable "custom_role_enabled" {
  description = "Set to true to enable custom role assignment to Key Vault"
  type        = bool
  default     = true
}

variable "custom_role_definition_id" {
  description = "The ID of the custom role definition"
  type        = string
  default     = ""
}

variable "custom_role_principal_id" {
  description = "The object ID of the principal (user/group/service principal) to assign the role to"
  type        = string
  default     = ""
}
