# Manage a RQL search on the Prisma Cloud Platform. This TF will create a RQL query in "My Recent Searches" under "Investigate"

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


resource "prismacloud_rql_search" "example" {
    search_type = "config"
    query = "config from cloud.resource where api.name = 'aws-ec2-describe-instances'"
    limit = 100
    time_range {
        relative {
            unit = "hour"
            amount = 24
        }
    }
}
