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

# Single Azure account type.
# resource "prismacloud_cloud_account" "rehan_azure_account" {
#     #disable_on_destroy = true
#     azure {
#         account_id = "<account id>"
#         enabled = true
#         group_ids = [
#             prismacloud_account_group.rehan-azure-accountgroup.group_id,
#         ]
#         name = "rehan-azure"
#         client_id = "<client id>"
#         key = "<key>"
#         tenant_id = "<tenant id>"
#         service_principal_id = "<service principal id>"
#         protection_mode = "MONITOR"
#       }
# }

resource "prismacloud_account_group" "rehan-azure-accountgroup" {
    name = "rehan-azure-account-group"
}


# Multiple Azure accounts onboarding via csv.
locals {
  azureinstances = csvdecode(file("azure.csv"))
}

resource "prismacloud_cloud_account" "csv" {
    for_each = { for inst in local.azureinstances : inst.name => inst }

    azure {
      account_id = each.value.accountid
      group_ids = split ("||", each.value.groupids)
      name = each.value.name
      client_id = each.value.clientid 
      key = each.value.key
      tenant_id = each.value.tenantid 
      service_principal_id = each.value.serviceprincipalid 
    }
}

