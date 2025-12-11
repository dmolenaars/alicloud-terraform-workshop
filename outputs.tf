# ============================================================================
# Outputs
# ============================================================================

output "ecs_instance_id" {
  description = "ID of the ECS instance"
  value       = alicloud_instance.workshop_ecs.id
}

output "nginx_url" {
  description = "URL to access the Nginx web server"
  value       = "http://${alicloud_instance.workshop_ecs.public_ip}"
}

output "vpc_id" {
  description = "ID of the VPC"
  value       = alicloud_vpc.workshop_vpc.id
}

output "vswitch_id" {
  description = "ID of the VSwitch"
  value       = alicloud_vswitch.workshop_vswitch.id
}

output "security_group_id" {
  description = "ID of the Security Group"
  value       = alicloud_security_group.workshop_sg.id
}
