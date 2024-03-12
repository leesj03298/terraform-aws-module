
resource "aws_eks_cluster" "default" {
  for_each = { for eks in var.eks_cluster : eks.identifier => eks if eks.identifier != null }
  name     = each.value.name
  role_arn = each.value.role_arn
  vpc_config {
    endpoint_private_access = each.value.endpoint_private_access
    endpoint_public_access  = each.value.endpoint_public_access
    public_access_cidrs     = each.value.public_access_cidrs
    security_group_ids      = each.value.security_group_ids
    subnet_ids              = each.value.subnet_ids
  }
  version = each.value.version
  tags = merge({
    "Name" = each.value.name
  }, each.value.tags)
}

resource "aws_eks_addon" "default" {
  for_each                    = { for eks_addon in var.eks_addon : join("-", [eks_addon.cluster_name, eks_addon.addon_name]) => eks_addon if eks_addon.identifier != null }
  cluster_name                = each.value.cluster_name
  addon_name                  = each.value.addon_name
  addon_version               = each.value.addon_version
  configuration_values        = jsonencode(each.value.configuration_values)
  resolve_conflicts_on_create = each.value.resolve_conflicts_on_create
  resolve_conflicts_on_update = each.value.resolve_conflicts_on_update
  service_account_role_arn    = each.value.service_account_role_arn
  preserve                    = each.value.preserve

  depends_on = [
    aws_eks_cluster.default
  ]
}