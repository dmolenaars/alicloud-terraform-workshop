# ============================================================================
# Variables
# ============================================================================

variable "region" {
  description = "The Alibaba Cloud region to deploy resources"
  type        = string
  default     = "eu-west-1"
}

variable "project_name" {
  description = "Name prefix for all resources"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "vswitch_cidr" {
  description = "CIDR block for the VSwitch"
  type        = string
  default     = "10.0.1.0/24"
}

variable "instance_type" {
  description = "ECS instance type"
  type        = string
  default     = "ecs.g9i.large"
}

variable "allowed_ip" {
  description = "IP address allowed to access the ECS instance (CIDR notation, e.g., 203.0.113.50/32)"
  type        = string
}
