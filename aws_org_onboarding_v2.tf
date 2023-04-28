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

provider "aws" {
  region = "us-east-1"
  access_key = "xxxxxxx" 
  secret_key = "xxxxxxx"
}

# Fetch Supported Features
data "prismacloud_account_supported_features" "prismacloud_supported_features_organization" {
    cloud_type = "aws"
    account_type = "organization"
}

# Fetch AWS CFT s3 presigned url based on required features
data "prismacloud_aws_cft_generator" "prismacloud_organization_cft" {
    account_type = "organization"
    account_id = "xxxxxxxxx"
    features = data.prismacloud_account_supported_features.prismacloud_supported_features_organization.supported_features
}

# Create the IAM Role AWS CloudFormation Stack using S3 presigned cft url
resource "aws_cloudformation_stack" "prismacloud_iam_role_stack_org" {
  name = "PrismaCloudOrgApp" // change if needed
  capabilities = ["CAPABILITY_NAMED_IAM"]
  parameters = {
    OrganizationalUnitIds = "r-cjvu" // 
    # PrismaCloudRoleName = "" // [Optional] A Default PrismaCloudRoleName will be present in CFT
  }
  template_url = data.prismacloud_aws_cft_generator.prismacloud_organization_cft.s3_presigned_cft_url
}

output "iam_role_org" {
    value = aws_cloudformation_stack.prismacloud_iam_role_stack_org.outputs.PrismaCloudRoleARN
}

# Onboard the cloud account onto prisma cloud platform
resource "prismacloud_org_cloud_account_v2" "aws_organization_onboarding_example" {
    disable_on_destroy = true
    aws {
        name = "RehanAWSOrg" // should be unique for each account
        account_id = "xxxxxxxxx"
        account_type = "organization"
        default_account_group_id = data.prismacloud_account_group.existing_account_group_id_org.group_id// To use existing Account Group
            // prismacloud_account_group.new_account_group.group_id, // To create new Account group
        group_ids = [
            data.prismacloud_account_group.existing_account_group_id_org.group_id,// To use existing Account Group
            // prismacloud_account_group.new_account_group.group_id, // To create new Account group
        ]
        role_arn = "${aws_cloudformation_stack.prismacloud_iam_role_stack_org.outputs.PrismaCloudRoleARN}" // IAM role arn from step 3
        # features {              // feature names from step 1
        #     name = "Remediation" // To enable Remediation also known as Monitor and Protect
        #     state = "enabled"
        # }
        # features {
        #     name = "Agentless Scanning" // To enable 'Agentless Scanning' feature if required.
        #    state = "enabled"
        # }
    }
}

// Retrive existing account group name id
data "prismacloud_account_group" "existing_account_group_id_org" {
    name = "Default Account Group" // Change the account group name, if you already have an account group that you wish to map the account. 
}

// To create a new account group, if required
# resource "prismacloud_account_group" "new_account_group" {
#     name = "MyNewAccountGroup" // Account group name to be creatd
# }
