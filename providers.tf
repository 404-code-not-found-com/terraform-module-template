###############################################################################
# providers.tf
#
# Contains all provider blocks and configuration.
###############################################################################

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
