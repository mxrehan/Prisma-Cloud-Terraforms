# This TF will create a custom policy, a custom compliance standard & attach the custom cumpliance standard
#to the created custom policy.

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

resource "prismacloud_policy" "Rehan-test-policy" {
    name = "Rehan-test-policy"
    policy_type = "config"
    severity = "low"
    cloud_type = "gcp"
    description = "test policy"
    compliance_metadata {
      compliance_id = "${prismacloud_compliance_standard_requirement_section.example.csrs_id}"
     }
 
    rule {
        name = "my rule"
        criteria = "xxxxxx"
        parameters = {
            "savedSearch": "true",
            "withIac": "false",
        }
        rule_type = "Config"
    }

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
