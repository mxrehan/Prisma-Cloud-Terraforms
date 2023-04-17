# Manage an account group. This TF will create an account group.
terraform {
  required_providers {
    prismacloud = {
      source = "PaloAltoNetworks/prismacloud"
      version = "1.3.1"
    }
  }
}

provider "prismacloud" {
    url = var.url
    username = var.username
    password = var.password
#     {
#     "url" : "<PRISMA_CLOUD_API_URL",
#     "username" : "<PRISMA_CLOUD_ACCESS_KEY>",
#     "password" : "<PRISMA_CLOUD_ACCESS_SECRET>"
# }
}

# locals {
#     account_groups = csvdecode(file("acc_grps.csv"))
# }

# // Now specify the account group resource with a loop like this:
# resource "prismacloud_account_group" "example" {
#         for_each = { for inst in local.account_groups : inst.name => inst }

#         name = each.value.name
#         account_ids = split("||", each.value.accountIDs)
#         description = each.value.description
# }

resource "prismacloud_account_group" "rehan-test-accountgroup" {
    name = "rehan-test-accountgroup"
    description = "Made by Terraform"
    account_ids = [ 212193468572 ]
}
