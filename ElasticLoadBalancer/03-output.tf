output "alb" {
  value = aws_lb.application_load_balancer
}

output "nlb" {
  value = aws_lb.network_load_balancer
}

output "tg" {
  value = aws_lb_target_group.default
}