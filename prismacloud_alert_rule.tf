# Manage an alert rule. This TF will create an alert rule with multiple account groups.

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


resource "prismacloud_alert_rule" "Rehan-test-alert-rule" {
    name = "Rehan-test-alert-rule"
    description = "Made by Terraform"
    enabled = "true"
    scan_all = true
    target {
    account_groups = ["accountgroup1", "accountgroup2" ]
    }
}