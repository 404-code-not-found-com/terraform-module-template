plugin "terraform" {
  enabled = true
  version = "0.14.1"
  source  = "github.com/terraform-linters/tflint-ruleset-terraform"
  preset  = "all"
}

plugin "aws" {
  enabled = true
  version = "0.47.0"
  source  = "github.com/terraform-linters/tflint-ruleset-aws"
}

plugin "azurerm" {
  enabled = true
  version = "0.31.1"
  source  = "github.com/terraform-linters/tflint-ruleset-azurerm"
}

plugin "google" {
  enabled = true
  version = "0.39.0"
  source  = "github.com/terraform-linters/tflint-ruleset-google"
}
