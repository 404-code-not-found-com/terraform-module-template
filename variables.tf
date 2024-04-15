###############################################################################
# variables.tf
#
# Contains all variable blocks in alphabetical order
#
# Two groups Required (no default values)
# Optional (has a default value)
###############################################################################

###############################################################################
# Required Variables (no default values)
###############################################################################
# variable "image_id" {
#   type        = string
#   description = "The id of the machine image (AMI) to use for the server."

#   validation {
#     condition     = length(var.image_id) > 4 && substr(var.image_id, 0, 4) == "ami-"
#     error_message = "The image_id value must be a valid AMI id, starting with \"ami-\"."
#   }
# }

###############################################################################
# Optional Variables (has a default value)
###############################################################################
# variable "instance_type" {
#   type        = string
#   description = "Instance Type"
#   default     = "t3.micro"
# }
