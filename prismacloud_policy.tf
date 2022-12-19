# Configure the prismacloud provider
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


# Retrieve the provider configuration from this JSON file. When retrieving params from the JSON configuration file, the param names are the same as the provider params, except that underscores in provider params become hyphens in the JSON config file. For example, the provider param json_web_token is json-web-token in the config file.

provider "prismacloud" {
  json_config_file = ".prismacloud_auth.json"
}

### Make sure to update the authentication file if using provider configuration file. 
# {
#     "url" : "<PRISMA_CLOUD_API_URL",
#     "username" : "<PRISMA_CLOUD_ACCESS_KEY>",
#     "password" : "<PRISMA_CLOUD_ACCESS_SECRET>"
# }

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




#### Prisma Cloud Custom Policies ####################################

# Configure a custom build policy from a local file
resource "prismacloud_policy" "build_policy_001" {
  name        = "build_policy_001: custom build policy #1 created with terraform"
  policy_type = "config"
  cloud_type  = "azure"
  severity    = "low"
  labels      = ["some_tag"]
  description = "this describes the policy"
  enabled     = false
  rule {
    name      = "build_policy_001: custom build policy #1 created with terraform"
    rule_type = "Config"
    parameters = {
      savedSearch = false
      withIac     = true
    }
    children {
      type           = "build"
      recommendation = "fix it"
      metadata = {
        "code" : file("policies/aks/aks001.yaml")
      }
    }
  }
}

# Configure a custom build policy from a one liner YAML code definition
resource "prismacloud_policy" "build_policy_002" {
  name        = "build_policy_002: custom build policy #2 created with terraform"
  policy_type = "config"
  cloud_type  = "azure"
  severity    = "low"
  labels      = ["some_tag"]
  description = "this describes the policy"
  enabled     = false
  rule {
    name      = "build_policy_002: custom build policy #1 created with terraform"
    rule_type = "Config"
    parameters = {
      savedSearch = false
      withIac     = true
    }
    children {
      type           = "build"
      recommendation = "fix it"
      metadata = {
        "code" : "---\nmetadata:\n  name: \"build_policy_002: a custom build policy created with terraform\"\n  guidelines: \"fix it\"\n  category: general\n  severity: high\nscope:\n  provider: azure\ndefinition:\n  and:\n    - cond_type: attribute\n      resource_types: \n      - azurerm_kubernetes_cluster\n      attribute: azure_active_directory_role_based_access_control\n      operator: exists\n    - cond_type: attribute\n      resource_types: \n      - azurerm_kubernetes_cluster\n      attribute: azure_active_directory_role_based_access_control.azure_rbac_enabled\n      operator: is_true\n",
      }
    }
  }
}

# Configure a custom run policy from a one liner RQL code definition
resource "prismacloud_policy" "run_policy_001" {
  name        = "run_policy_001: custom run policy #1 created with terraform"
  policy_type = "config"
  cloud_type  = "azure"
  severity    = "low"
  labels      = ["some_tag"]
  description = "this describes the policy"
  enabled     = false
  rule {
    name      = "run_policy_001: custom run policy #1 created with terraform"
    rule_type = "Config"
    parameters = {
      savedSearch = false
      withIac     = false
    }
    criteria = "config from cloud.resource where cloud.type = 'azure' AND api.name = 'azure-kubernetes-cluster' AND json.rule =  properties.enableRBAC is false"

  }
}

# Configure a custom run policy from a local file
resource "prismacloud_policy" "run_policy_002" {
  name        = "run_policy_002: custom run policy #2 created with terraform"
  policy_type = "config"
  cloud_type  = "azure"
  severity    = "low"
  labels      = ["some_tag"]
  description = "this describes the policy"
  enabled     = false
  rule {
    name      = "run_policy_002: custom run policy #2 created with terraform"
    rule_type = "Config"
    parameters = {
      savedSearch = false
      withIac     = false
    }
    criteria = file("policies/aks/aks001.rql")
  }
}

# Configure a custom run policy from a saved RQL search
resource "prismacloud_policy" "run_policy_003" {
  name        = "run_policy_003: custom run policy #3 created with terraform"
  policy_type = "config"
  cloud_type  = "azure"
  severity    = "low"
  labels      = ["some_tag"]
  description = "this describes the policy"
  enabled     = false
  rule {
    name      = "run_policy_003: custom run policy #3 created with terraform"
    rule_type = "Config"
    parameters = {
      savedSearch = true
      withIac     = false
    }
    criteria = prismacloud_saved_search.run_policy_003.id
  }
}
resource "prismacloud_saved_search" "run_policy_003" {
  name        = "run_policy_003"
  description = "run_policy_003: saved RQL search"
  search_id   = prismacloud_rql_search.run_policy_003.search_id
  query       = prismacloud_rql_search.run_policy_003.query
  time_range {
    relative {
      unit   = prismacloud_rql_search.run_policy_003.time_range.0.relative.0.unit
      amount = prismacloud_rql_search.run_policy_003.time_range.0.relative.0.amount
    }
  }
}
resource "prismacloud_rql_search" "run_policy_003" {
  search_type = "config"
  query       = "config from cloud.resource where cloud.type = 'azure' AND api.name = 'azure-kubernetes-cluster' AND json.rule =  properties.addonProfiles.omsagent.config does not exist or properties.addonProfiles.omsagent.enabled is false"
  time_range {
    relative {
      unit   = "hour"
      amount = 24
    }
  }
}

