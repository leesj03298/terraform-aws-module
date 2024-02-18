locals {
  middle_name        = var.middle_name
  cluster_identifier = join("-", ["rs", local.middle_name, var.name_prefix])
}

data "aws_iam_role" "default_role" {
  count    = var.default_iam_role_name != null && var.default_iam_role_name != "" ? 1 : 0
  name     = var.default_iam_role_name
}

data "aws_iam_role" "roles" {
  for_each = toset(var.iam_role_names)
  name     = each.key
}

#### Redshift ##########################################################################################################
resource "aws_redshift_cluster" "default" {
  for_each                             = toset([local.cluster_identifier])
  cluster_identifier                   = each.key
  database_name                        = var.database_name
  master_username                      = var.master_username
  master_password                      = var.master_password
  node_type                            = var.node_type
  number_of_nodes                      = var.number_of_nodes
  cluster_type                         = var.number_of_nodes > 1 ? "multi-node" : "single-node"
  cluster_subnet_group_name            = var.cluster_subnet_group_name
  cluster_parameter_group_name         = var.cluster_parameter_group_name
  publicly_accessible                  = var.publicly_accessible
  vpc_security_group_ids               = [for scg_identifier in var.vpc_security_group_identifiers : var.scg_id[scg_identifier]]
  skip_final_snapshot                  = var.skip_final_snapshot
  availability_zone_relocation_enabled = var.availability_zone_relocation_enabled
  encrypted                            = true
  availability_zone                    = alltrue([var.availability_zone_relocation_enabled, var.availability_zone != null]) ? var.publicly_accessible : null
  default_iam_role_arn                 = try(data.aws_iam_role.default_role[0].arn, null)
  iam_roles                            = [for key in var.iam_role_names : data.aws_iam_role.roles[key].arn] 

  timeouts {
    create = "10m"
    update = "20m"
    delete = "10m"
  }
}