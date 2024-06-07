###############################################################################
# terraform.tf
#
# Contains a single terraform block which defines your required_version and
# required_providers.
###############################################################################

terraform {
  required_version = "~> 1.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
    hcp = {
      source  = "hashicorp/hcp"
      version = "~>0.54"
    }
  }
}
