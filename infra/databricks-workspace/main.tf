data "terraform_remote_state" "network" {
  backend = "s3"

  config = {
    bucket = "dp-tf-state-763432567385"
    key    = "${var.environment}/network/terraform.tfstate"
    region = "${var.region}"
  }
}


data "terraform_remote_state" "iam" {
  backend = "s3"

  config = {
    bucket = "dp-tf-state-763432567385"
    key    = "${var.environment}/iam/terraform.tfstate"
    region = "${var.region}"
  }
}

data "terraform_remote_state" "storage" {
  backend = "s3"

  config = {
    bucket = "dp-tf-state-763432567385"
    key    = "${var.environment}/storage/terraform.tfstate"
    region = "${var.region}"
  }
}


resource "databricks_mws_storage_configurations" "this" {
  account_id                  = var.databricks_account_id
  storage_configuration_name  = "dp-${var.environment}-storage"
  bucket_name                 = data.terraform_remote_state.storage.outputs.databricks_root_bucket
}


resource "databricks_mws_credentials" "this" {
  credentials_name = "dp-${var.environment}-credentials"
  role_arn         = data.terraform_remote_state.iam.outputs.databricks_role_arn
}


resource "databricks_mws_networks" "this" {
  account_id   = var.databricks_account_id
  network_name = "dp-${var.environment}-network"

  vpc_id     = data.terraform_remote_state.network.outputs.vpc_id
  subnet_ids = data.terraform_remote_state.network.outputs.private_subnet_ids

  security_group_ids = [
    data.terraform_remote_state.network.outputs.databricks_security_group_id
  ]
}


resource "databricks_mws_workspaces" "workspace" {
  account_id = var.databricks_account_id
  workspace_name = "dp-${var.environment}-workspace"
  aws_region = var.region

  credentials_id = databricks_mws_credentials.this.credentials_id
  network_id = databricks_mws_networks.this.network_id
  storage_configuration_id = databricks_mws_storage_configurations.this.storage_configuration_id
}
