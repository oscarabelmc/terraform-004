terraform {
  required_version = ">= 1.5"
  required_providers {
    tfe = {
      source  = "hashicorp/tfe"
      version = "~> 0.50"
    }
  }
}

variable "third_party_api_token" {
  type      = string
  sensitive = true
}

variable "third_party_api_secret" {
  type      = string
  sensitive = true
}

# Step 1: Group workspaces into a project
resource "tfe_project" "app_team" {
  name         = "app-team-project"
  organization = "my-org"
}

resource "tfe_workspace" "app_dev" {
  name         = "app-dev"
  project_id   = tfe_project.app_team.id
  organization = "my-org"
}

# Step 2: Create a variable set with credentials
resource "tfe_variable_set" "third_party_creds" {
  name         = "third-party-credentials"
  description  = "Shared credentials for third-party API"
  organization = "my-org"
}

resource "tfe_variable" "api_token" {
  key             = "API_TOKEN"
  value           = var.third_party_api_token
  category        = "terraform"
  sensitive       = true
  variable_set_id = tfe_variable_set.third_party_creds.id
}

resource "tfe_variable" "api_secret" {
  key             = "API_SECRET"
  value           = var.third_party_api_secret
  category        = "terraform"
  sensitive       = true
  variable_set_id = tfe_variable_set.third_party_creds.id
}

# Step 3: Apply variable set to the project
resource "tfe_project_variable_set" "app_team_creds" {
  variable_set_id = tfe_variable_set.third_party_creds.id
  project_id      = tfe_project.app_team.id
}
