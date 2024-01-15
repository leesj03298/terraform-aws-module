output "vpce_interface_arn" {
    description = "The arn of the Endpoint(Type : Interface)"
    value       = { for key, vpce in aws_vpc_endpoint.VPC_Endpoint_Interface : key => vpce.arn}
}

output "vpce_interface_service_name" {
    description = "The service_name of the Endpoint(Type : Interface)"
    value       = { for key, vpce in aws_vpc_endpoint.VPC_Endpoint_Interface : key => vpce.service_name}
}

output "vpce_interface_securitygroup_id" {
    description = "The security_group_ids name of the Endpoint(Type : Interface)"
    value       = { for key, vpce in aws_vpc_endpoint.VPC_Endpoint_Interface : key => vpce.security_group_ids}
}

output "vpce_interface_subnet_id" {
    description = "The subnet_ids name of the Endpoint(Type : Interface)"
    value       = { for key, vpce in aws_vpc_endpoint.VPC_Endpoint_Interface : key => vpce.subnet_ids}
}

output "vpce_gateweay_arn" {
    description = "The arn of the Endpoint(Type : Gateway)"
    value       = { for key, vpce in aws_vpc_endpoint.VPC_Endpoint_Gateway : key => vpce.arn}
}

output "vpce_gateweay_service_name" {
    description = "The service_name of the Endpoint(Type : Gateway)"
    value       = { for key, vpce in aws_vpc_endpoint.VPC_Endpoint_Gateway : key => vpce.service_name}
}