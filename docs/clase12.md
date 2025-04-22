# Material para la clase 12

Crea un archivo llamado **backend.tf**, no olvides que debes tener ya tu cuenta de almacenamiento creada.

```terraform
terraform {
  backend "azurerm" {
    storage_account_name = "generalstorageamin"
    container_name       = "tfstate"
    key                  = "devops.tfstate"
  }
}
```

Luego crea un archivo llamado **provider.tf**

```terraform
terraform {
  required_version = ">=1.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
  }
}
provider "azurerm" {
  features {}
  subscription_id = "30a83aff-7a8b-4ca3-aa48-ab93268b5a8b"
}
```

Crea después **variables.tf**

```terraform
variable "resource_group_name_prefix" {
  description = "Prefix for the resource group name"
  type        = string
  default     = "rg-" 
}

variable "resource_group_location" {
  description = "Location for the resource group"
  type        = string
  default     = "East US 2"
}

variable "acr_name" {
  description = "Name of the Azure Container Registry"
  type        = string
  default     = "acrdevopsamin"
}

variable "container_app_env_name" {
  description = "Name of the Azure Container App Environment"
  type        = string
  default     = "devops-env"
}
```

Y por último **main.tf**.

```terraform
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
```

Ejecuta los comandos:

```bash
terraform init -backend-config="sas_token=<el sas token>"

terraform plan -out plan.out

terraform apply "plan.out"

terraform destroy
```
