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

provider "aws" {
  region = "us-east-1"
  access_key = "xxxxxxxx"
  secret_key = "xxxxxxxx"
}

# Fetch Supported Features
data "prismacloud_account_supported_features" "prismacloud_supported_features" {
    cloud_type = "aws"
    account_type = "account"
}

# Fetch AWS CFT s3 presigned url based on required features
data "prismacloud_aws_cft_generator" "prismacloud_account_cft" {
    account_type = "account"
    account_id = "xxxxxxx"
    features = data.prismacloud_account_supported_features.prismacloud_supported_features.supported_features
}

# Create the IAM Role AWS CloudFormation Stack using S3 presigned cft url 
resource "aws_cloudformation_stack" "prismacloud_iam_role_stack" {
  name = "PrismaCloudApp" // change if needed
  capabilities = ["CAPABILITY_NAMED_IAM"]
#   parameters { // optional
#     PrismaCloudRoleName="" 
#   }
  template_url = data.prismacloud_aws_cft_generator.prismacloud_account_cft.s3_presigned_cft_url
}

# Onboard the cloud account onto prisma cloud platform
resource "prismacloud_cloud_account_v2" "aws_account_onboarding_example" {
    disable_on_destroy = true
    aws {
        name = "myAwsAccountName" // should be unique for each account
        account_id = "xxxxxxxxxx"
        group_ids = [
            data.prismacloud_account_group.existing_account_group_id.group_id,// To use existing Account Group
            // prismacloud_account_group.new_account_group.group_id, // To create new Account group
        ]
        role_arn = "${aws_cloudformation_stack.prismacloud_iam_role_stack.outputs.PrismaCloudRoleARN}" // IAM role arn from prismacloud_iam_role_stack resource
        // features {              // feature names from prismacloud_supported_features data source
        //     name = "Remediation" // To enable Remediation also known as Monitor and Protect
        //     state = "enabled"
        // }
        // features {
        //     name = "Agentless Scanning" // To enable 'Agentless Scanning' feature if required.
        //     state = "enabled"
        // }
    }
}

// Retrive existing account group name id
data "prismacloud_account_group" "existing_account_group_id" {
    name = "Default Account Group" // If you already have an account group that you wish to map the account then change the account group name, 
}

// To create a new account group
# resource "prismacloud_account_group" "new_account_group" {
#     name = "MyNewAccountGroup" // Account group name to be created
# }
