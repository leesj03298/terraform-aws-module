locals {
  middle_name        = var.middle_name
  cluster_identifier = join("-", ["rs", local.middle_name, var.name_prefix])
}

#### Redshift ##########################################################################################################
resource "aws_redshift_cluster" "default" {
  for_each                     = toset([local.cluster_identifier])
  cluster_identifier           = each.key
  database_name                = var.database_name
  master_username              = var.master_username
  master_password              = var.master_password
  node_type                    = var.node_type
  cluster_type                 = var.cluster_type
  cluster_subnet_group_name    = var.cluster_subnet_group_name
  cluster_parameter_group_name = var.cluster_parameter_group_name
  vpc_security_group_ids       = [for scg_identifier in var.vpc_security_group_identifiers : var.scg_id[scg_identifier]]
  skip_final_snapshot          = var.skip_final_snapshot
  timeouts {
    create = "10m"
    update = "20m"
    delete = "10m"
  }
}