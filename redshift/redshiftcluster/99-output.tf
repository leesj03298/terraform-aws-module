# output "aws_redshift_cluster" {
#   value = aws_redshift_cluster.default[*]
# }

output "dns_name" {
  value = { for key, value in aws_redshift_cluster.default : key => value.dns_name }
}

output "dns_node_type" {
  value = { for key, value in aws_redshift_cluster.default : key => value.node_type }
}

output "dns_number_of_nodes" {
  value = { for key, value in aws_redshift_cluster.default : key => value.number_of_nodes }
}