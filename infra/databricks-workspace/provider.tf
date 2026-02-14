terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }

    databricks = {
      source  = "databricks/databricks"
      version = "~> 1.30"
    }
  }
}

provider "aws" {
  region = var.region
}

provider "databricks" {
  host = "https://accounts.cloud.databricks.com"
}
