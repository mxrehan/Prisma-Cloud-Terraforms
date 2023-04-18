# Manage an alert rule. This TF will create an alert rule with multiple account groups.
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
}

resource "prismacloud_alert_rule" "Rehan-test-alert-rule" {
    name = "Rehan-test-alert-rule"
    description = "Made by Terraform"
    allow_auto_remediate = false
    enabled = "true"
    scan_all = true
    target {
    account_groups = ["8501242b-f06d-4048-bb25-7e75aa11602c" ]
    }
}
