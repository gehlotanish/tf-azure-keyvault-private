variable "keyvaults" {
  type = map(object({
    name                          = string
    location                      = string
    sku                           = optional(string, "standard")
    soft_delete_retention_days    = optional(number, 90)
    purge_protection              = optional(bool, false)
    public_network_access_enabled = optional(bool, true)
    enable_rbac_authorization     = optional(bool, false)
    environment                   = optional(string, "production")
    keyvault_extra_tags           = optional(map(string), {})
    network_acls = optional(object({
      bypass                     = string
      default_action             = string
      ip_rules                   = list(string)
      virtual_network_subnet_ids = list(string)
    }), null)
    key_permissions           = optional(list(string), ["Create", "Get"])
    secret_permissions        = optional(list(string), ["Set", "Get", "Delete", "Purge", "Recover"])
    certificate_permissions   = optional(list(string), ["Get", "List"])
    diag_enabled              = optional(bool, false)
    custom_role_enabled       = optional(bool, true)
    custom_role_definition_id = optional(string, "")
    custom_role_principal_id  = optional(string, "")
    private_endpoint = optional(object({
      enabled                 = bool
      subnet_id               = string
      private_dns_zone_id     = optional(string, null)
      private_connection_name = optional(string, null)
      network_interface_name  = optional(string, null)
      request_message         = optional(string, "Auto-Approved")
      subresource_names       = optional(list(string), ["vault"])
      is_manual_connection    = optional(bool, false)
    }), null)
  }))
  description = "Map of Key Vault configurations. Each Key Vault must have a unique name (globally unique, 3-24 characters, alphanumeric and hyphens only) and location. All other parameters are optional with defaults."
}

variable "resource_group_name" {
  type        = string
  description = "The name of the Azure Resource Group where the Key Vault will be created."
}

variable "log_analytics_resource_group_name" {
  type        = string
  description = "The name of the Azure Resource Group containing the existing Log Analytics Workspace used for diagnostic settings."
}

variable "log_analytics_workspace_name" {
  type        = string
  default     = null
  description = "The name of an existing Log Analytics Workspace to use for diagnostic settings. If null, diagnostics will not be configured even if diag_enabled is true for a Key Vault."
}
