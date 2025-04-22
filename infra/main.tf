resource "random_pet" "rg_name" {
  prefix = var.resource_group_name_prefix
}

resource "azurerm_resource_group" "rg" {
  name     = random_pet.rg_name.id
  location = var.resource_group_location
}

resource "azurerm_application_insights" "app_insights" {
  name = "${var.resource_group_name_prefix}-ai"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  application_type    = "web"
  workspace_id       = azurerm_log_analytics_workspace.log_analytics.id
}

resource "azurerm_log_analytics_workspace" "log_analytics" {
  name                = "${var.resource_group_name_prefix}-law"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "PerGB2018"
  retention_in_days   = 30

  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_container_app_environment" "apps_environment" {
  name                       = var.container_app_env_name
  location                   = azurerm_resource_group.rg.location
  resource_group_name        = azurerm_resource_group.rg.name
  log_analytics_workspace_id = azurerm_log_analytics_workspace.log_analytics.id
}