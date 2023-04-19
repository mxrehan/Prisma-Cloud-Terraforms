# This TF will manage a custom permission group
terraform {
  required_providers {
    prismacloud = {
      source = "PaloAltoNetworks/prismacloud"
      version = "1.3.4"
    }
  }
}

provider "prismacloud" {
    url = var.url
    username = var.username
    password = var.password
}

resource "prismacloud_permission_group" "example" {
  name = "test permission group"
  description = "Made by Terraform"
  features{
    feature_name= "settingsAuditLogs"
    #featureName= "alertsOverview"
    #featureName= "alertsAlertRules"
    #featureName= "assetInventoryFilters"
    #featureName= "settingsCloudAccounts"
    operations {
      read= true
      #create=true
      #update=true
      #delete=true
    }
  }
}
