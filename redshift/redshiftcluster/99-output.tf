# output "aws_redshift_cluster" {
#   value = aws_redshift_cluster.default[*]
# }

output "dns_name" {
  value = { for key, value in aws_redshift_cluster.default : key => value.dns_name }
}

output "node_type" {
  value = { for key, value in aws_redshift_cluster.default : key => value.node_type }
}

output "number_of_nodes" {
  value = { for key, value in aws_redshift_cluster.default : key => value.number_of_nodes }
}

output "publicly_accessible" {
  value = { for key, value in aws_redshift_cluster.default : key => value.publicly_accessible }
}

output "availability_zone_relocation_enabled" {
  value = { for key, value in aws_redshift_cluster.default : key => value.availability_zone_relocation_enabled }
}

output "default_iam_role_arn" {
  value = { for key, value in aws_redshift_cluster.default : key => value.default_iam_role_arn }
}

output "iam_roles" {
  value = { for key, value in aws_redshift_cluster.default : key => value.iam_roles }
}