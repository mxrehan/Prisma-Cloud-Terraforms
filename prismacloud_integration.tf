# Manages an integration. This TF will create an aws security hub integration.

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


resource "prismacloud_integration" "security_hub" {

    name = "Rehan-test"
    integration_type = "aws_security_hub"
    description = "Made by Terraform"
    enabled = true
    integration_config {
        account_id = "accountid"
        regions {
            api_identifier = "us-west-2"
            name = "AWS Virginia"
        }
    }
}