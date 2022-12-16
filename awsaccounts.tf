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

# Single AWS account type.
#resource "prismacloud_cloud_account" "aws_example" {
#    disable_on_destroy = true
#    aws {
#        name = "myAwsAccountName"
#        account_id = "accountIdHere"
#        external_id = "eidHere"
#        group_ids = [
#            prismacloud_account_group.g1.group_id,
#        ]
#        role_arn = "some:arn:here"
#    }
#}

#resource "prismacloud_account_group" "g1" {
#    name = "My group"
#}

/*
You can also create cloud accounts from a CSV file using native Terraform
HCL and looping.  Assume you have a CSV file of AWS accounts that looks like this (with
"||" separating account group IDs from each other):

accountId,externalId,groupIDs,name,roleArn
123456789,PrismaExternalId,Default Account Group||AWS Account Group,123466789,arn:aws:iam::123456789:role/RedlockReadWriteRole
213456789,PrismaExternalId,Default Account Group||AWS Account Group,213456789,arn:aws:iam::213456789:role/RedlockReadWriteRole
321466019,PrismaExternalId,Default Account Group||AWS Account Group,321466019,arn:aws:iam::321466019:role/RedlockReadWriteRole

Here's how you would do this (Terraform 0.12 code):
*/

locals {
  instances = csvdecode(file("aws.csv"))
}

resource "prismacloud_cloud_account" "csv" {
    for_each = { for inst in local.instances : inst.name => inst }

    aws {
        name = each.value.name
        account_id = each.value.accountId
        external_id = each.value.externalId
        group_ids = split("||", each.value.groupIDs)
        role_arn = each.value.roleArn
    }
}