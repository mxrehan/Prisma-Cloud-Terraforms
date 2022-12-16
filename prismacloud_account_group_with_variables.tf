# Manage an account group. This TF will create an account group.

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


resource "prismacloud_account_group" "rehan-test-accountgroup" {
    name = "rehan-test-accountgroup"
    description = "Made by Terraform"
    account_ids = [ accountid1,accountid2 ]
}