terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.44.1"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg-webapp" {
  name     = "rg-webapp"
  location = "East US"
}

resource "azurerm_service_plan" "mywebappplan-4302" {
  name                = "mywebappplan-4302"
  resource_group_name = azurerm_resource_group.rg-webapp.name
  location            = azurerm_resource_group.rg-webapp.location
  os_type             = "Linux"
  sku_name            = "S1"
}

resource "azurerm_linux_web_app" "mywebapp-php" {
  name                = "mywebapp-php"
  resource_group_name = azurerm_resource_group.rg-webapp.name
  location            = azurerm_resource_group.rg-webapp.location
  service_plan_id     = azurerm_service_plan.mywebappplan-4302.id

  site_config {
    application_stack {
      php_version = "8.0"

    }
  }
}

resource "azurerm_app_service_source_control" "source_control" {
  app_id   = azurerm_linux_web_app.mywebapp-php.id
  repo_url = "https://github.com/gvndverma787/simple-php-website.git"
  branch   = "master"
}


output "app_url" {
    description = "show webapp url"
    value = azurerm_linux_web_app.mywebapp-php.default_hostname
  
}
