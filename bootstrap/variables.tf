##############################################
# Declare variables 
##############################################

# Set region
variable "region" {
  description = "AWS region"
  type        = string
}

# Set state bucket name
variable "state_bucket_name" {
  description = "Terraform state bucket name"
  type        = string
}

# Set dynamoDB lock table name
variable "lock_table_name" {
  description = "DynamoDB table for state locking"
  type        = string
}