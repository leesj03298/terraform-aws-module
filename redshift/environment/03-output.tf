output "redshift_subnet_group" {
  value = aws_redshift_subnet_group.default[*]
}

output "redshift_parameter_group" {
  value = aws_redshift_parameter_group.default[*]
}