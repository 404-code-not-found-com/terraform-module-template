###############################################################################
# terraform.tf
#
# Terraform and Provider blocks
###############################################################################

terraform {
  required_version = "~> 1.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~>4.55"
    }
    hcp = {
      source  = "hashicorp/hcp"
      version = "~>0.54"
    }
  }
}

provider "google" {
  # Configuration options
  # Environment variables needed for auth
  # GOOGLE_OAUTH_ACCESS_TOKEN="..."
  # GOOGLE_PROJECT="..."
  # GOOGLE_REGION="..."
  # GOOGLE_ZONE="..."
}

provider "hcp" {
  # Configuration options
  # Environment variables needed for auth
  # HCP_CLIENT_ID="..."
  # HCP_CLIENT_SECRET="..."
}
