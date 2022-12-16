# Azure Cloud Account Onboarding

terraform {
  required_providers {
    prismacloud = {
      source = "PaloAltoNetworks/prismacloud"
      version = "1.2.10"
    }
  }
}

provider "prismacloud" {
    url = var.url
    username = var.username
    password = var.password
}


# Single gcp account type.
resource "prismacloud_cloud_account" "rehan_azure_account" {
    #disable_on_destroy = true
    gcp {
        account_id = "<name>"
        enabled = true
        group_ids = [
            prismacloud_account_group.rehan-gcp-accountgroup.group_id,
        ]
        name = "rehan-gcp"
        credentials_json = file ("filename.json")
        protection_mode = "MONITOR"
      }
}

resource "prismacloud_account_group" "rehan-gcp-accountgroup" {
    name = "rehan-gcp-account-group"
}