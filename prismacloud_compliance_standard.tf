# Manage a compliance standard.. This TF will create a compliance standard and attach compliance standard requirements to it.

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

resource "prismacloud_compliance_standard" "Rehan-test-compliance-standard" {
    name = "Rehan-test-compliance-standard"
    description = "Made by Terraform"
}

resource "prismacloud_compliance_standard_requirement" "Rehan-test-compliance-standard-requirement" {
    cs_id = prismacloud_compliance_standard.Rehan-test-compliance-standard.cs_id
    name = "Rehan-test-requirement"
    description = "Also made by Terraform"
    requirement_id = "1.007"
}

resource "prismacloud_compliance_standard_requirement_section" "example" {
    csr_id = prismacloud_compliance_standard_requirement.Rehan-test-compliance-standard-requirement.csr_id
    section_id = "Section 1"
    description = "Section description"
}
