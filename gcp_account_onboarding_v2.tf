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
#   cloud_type      = "gcp"
#   account_type    = "account"   //"account" or "masterServiceAccount"
# }

# data "prismacloud_gcp_template" "prismacloud_gcp_template" {
#   name = "test account"
#   account_type = "account"   //"account" or "masterServiceAccount"
#   project_id = "xxxxxxx"
#   authentication_type = "service_account"
#   file_name = "gcp_onboarding" //Provide filename along with path to store gcp template
#   features = data.prismacloud_account_supported_features.prismacloud_supported_features.supported_features
# }

resource "prismacloud_cloud_account_v2" "gcp_account_onboarding_example" {
   disable_on_destroy = true
   gcp {
    account_id = "xxxxxxxx"
     account_type = "account"   //"account" or "masterServiceAccount"
     enabled = true
     name = "Finance" //Should be unique for each account
     group_ids    = [  //Should be given for gcp project account
       data.prismacloud_account_group.existing_account_group_id.group_id, //To use existing Account Group
       //prismacloud_account_group.new_account_group.group_id, // To create new Account group
     ]
     compression_enabled = false
     credentials = file("xxxxxxxxxx") //File containing credentials
     features {
       name = "Agentless Scanning" //To enable 'Agentless Scanning' feature if required.
       state = "enabled"
     }
     features {
       name = "Remediation"  //To enable Remediation also known as Monitor and Protect
       state = "disabled"
     }
     default_account_group_id = data.prismacloud_account_group.existing_account_group_id.group_id //To use existing Account Group
       //prismacloud_account_group.new_account_group.group_id, // To create new Account group
   }
 }
 // Retrive existing account group name id
 data "prismacloud_account_group" "existing_account_group_id" {
   name = "Default Account Group"
   // Change the account group name, if you already have an account group that you wish to map the account. 
 }

// // To create a new account group, if required
// # resource "prismacloud_account_group" "new_account_group" {
// #     name = "MyNewAccountGroup" // Account group name to be created
// # }
