output "Network_Load_Balancer_arn" {
    description = "The arn of the Network Load Balancer"
    value = {for k, Load_Balancer in aws_lb.Network_Load_Balancer : k => Load_Balancer.arn }
}

output "Application_Load_Balancer_arn" {
    description = "The arn of the Application Load Balancer"
    value = {for k, Load_Balancer in aws_lb.Application_Load_Balancer : k => Load_Balancer.arn }
}

output "Network_Load_Balancer_dns" {
    description = "The dns_name of the Network Load Balancer"
    value = {for k, Load_Balancer in aws_lb.Network_Load_Balancer : k => Load_Balancer.dns_name }
}

output "Application_Load_Balancer_dns" {
    description = "The dns_name of the Application Load Balancer"
    value = {for k, Load_Balancer in aws_lb.Application_Load_Balancer : k => Load_Balancer.dns_name }
}


output "Network_Load_Balancer_subnets" {
    description = "The subnets of the Network Load Balancer"
    value = {for k, Load_Balancer in aws_lb.Network_Load_Balancer : k => Load_Balancer.subnets }
}

output "Application_Load_Balancer_subnets" {
    description = "The subnets of the Application Load Balancer"
    value = {for k, Load_Balancer in aws_lb.Application_Load_Balancer : k => Load_Balancer.subnets }
}

output "Network_Load_Balancer_enable_cross_zone_load_balancing" {
    description = "The cross_zone_load_balancing of the Network Load Balancer"
    value = {for k, Load_Balancer in aws_lb.Network_Load_Balancer : k => Load_Balancer.enable_cross_zone_load_balancing }
}

output "target_group" {
    value = aws_lb_target_group.this
}

output "target_group_attachment" {
    description = "The Target Id and Port of the Target Group"
    value       = { for tg_key, tg in aws_lb_target_group.this : tg_key => values({
                    for tga_key, tga in aws_lb_target_group_attachment.this : tga_key => "target_id : ${tga.target_id}, port : ${tga.port}"
                    if split("_",tga_key)[0] == tg_key
                })
            }
}

output "aws_lb_listener" {
    value = aws_lb_listener.Network_Load_Balancer_Listener
}