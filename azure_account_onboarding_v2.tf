terraform {
  required_providers {
    prismacloud = {
      source = "PaloAltoNetworks/prismacloud"
      version = "1.3.7"
    }
  }
}

provider "prismacloud" {
    url = var.url
    username = var.username
    password = var.password
}

# data "prismacloud_account_supported_features" "prismacloud_supported_features" {
#   cloud_type      = "azure"
#   account_type    = "account"
#   deployment_type = "azure"
# }

# output "features_supported" {
#   value = data.prismacloud_account_supported_features.prismacloud_supported_features.supported_features
# }

# data "prismacloud_azure_template" "prismacloud_azure_template" {
#   file_name       = "azure_onboarding" //Provide filename along with path to store azure template
#   account_type    = "account"
#   tenant_id       = "xxxxxxx"
#   deployment_type = "azure"
#   subscription_id = "xxxxxxx"
#   features        = data.prismacloud_account_supported_features.prismacloud_supported_features.supported_features
# }

resource "prismacloud_cloud_account_v2" "azure_account_onboarding_example" {
  disable_on_destroy = true
  azure {
    client_id    = "xxxxxxxx"
    account_id   = "xxxxxxxx"
    account_type = "account"
    enabled      = true
    name         = "Azure USA" //Should be unique for each account
    group_ids    = [
      data.prismacloud_account_group.existing_account_group_id.group_id, //To use existing Account Group
      //prismacloud_account_group.new_account_group.group_id, //To create new Account group
    ]
    key                  = "xxxxxxxx"
    monitor_flow_logs    = true
    service_principal_id = "xxxxxxxx"
    tenant_id            = "xxxxxxxx"
    features {
      name  = "Agentless Scanning" //To enable 'Agentless Scanning' feature if required.
      state = "enabled"
    }
    features {
      name  = "Remediation"  //To enable Remediation also known as Monitor and Protect
      state = "enabled"
    }
  }
}

// Retrive existing account group name id
data "prismacloud_account_group" "existing_account_group_id" {
  name = "Default Account Group"
  //Change the account group name, if you already have an account group that you wish to map the account. 
}

// // To create a new account group, if required
// resource "prismacloud_account_group" "new_account_group" {
//      name = "MyNewAccountGroup" //Account group name to be created
//  }
