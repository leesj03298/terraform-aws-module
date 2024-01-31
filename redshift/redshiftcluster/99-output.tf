# output "aws_redshift_cluster" {
#   value = aws_redshift_cluster.default[*]
# }

output "dns_name" {
    value = {for key, value in aws_redshift_cluster.default : key => value.dns_name}
}