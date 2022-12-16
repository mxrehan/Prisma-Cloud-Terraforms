# Manage an alert rule. This TF will create a custom policy of type config.

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

resource "prismacloud_policy" "Rehan-test-policy" {
    name = "Rehan-test-policy"
    policy_type = "config"
    severity = "low"
    cloud_type = "gcp"
    description = "test policy"
    compliance_metadata {
      compliance_id = "xxxxxx" 
      #standard_name = "SOC2"
      #requirement_name = "Logical and Physical Access Controls"
      #section_id = "CC6.1"
      #section_description = "The entity implements logical access security software, 
      #infrastructure, and architectures over protected information assets to protect 
      #them from security events to meet the entity's objectives."
     }
    compliance_metadata {
      compliance_id = "xxxxx" 
      #standard_name = "SOC2"
      #requirement_name = "Logical and Physical Access Controls"
      #section_id = "CC6.2"
      #section_description = "Prior to issuing system credentials and granting system access, 
      #the entity registers and authorizes new internal and external users whose access is 
      #administered by the entity. For those users whose access is administered by the entity, 
      #user system credentials are removed when user access is no longer authorized."
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