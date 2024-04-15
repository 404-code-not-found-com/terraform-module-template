###############################################################################
# backend.tf
#
# Contains your backend configuration
###############################################################################

# Documentation
# https://developer.hashicorp.com/terraform/language/settings/backends/configuration

# terraform {
#   backend "remote" {
#     organization = "example_corp"

#     workspaces {
#       name = "my-app-prod"
#     }
#   }
# }

# Terraform Cloud storage block for CLI driven
# https://developer.hashicorp.com/terraform/language/settings/terraform-cloud

# terraform {
#   cloud {
#     organization = "example_corp"
#     ## Required for Terraform Enterprise; Defaults to app.terraform.io for Terraform Cloud
#     hostname = "app.terraform.io"

#     workspaces {
#       tags = ["app"]
#     }
#   }
# }
