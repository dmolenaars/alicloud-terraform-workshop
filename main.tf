# Alibaba Cloud Terraform Workshop
# This project deploys a VPC, Security Group, and ECS instance running Nginx

terraform {
  required_version = ">= 1.0.0"

  required_providers {
    alicloud = {
      source  = "aliyun/alicloud"
      version = ">= 1.200.0"
    }
  }
}

# Configure the Alibaba Cloud Provider
provider "alicloud" {
  region = var.region
}

# Data source to get available zones
data "alicloud_zones" "default" {
  available_instance_type     = var.instance_type
  available_resource_creation = "VSwitch"
}

# Data source to get the latest Ubuntu image
data "alicloud_images" "ubuntu" {
  name_regex  = "^ubuntu_22"
  most_recent = true
  owners      = "system"
}

# ============================================================================
# VPC & VSwitch
# ============================================================================

resource "alicloud_vpc" "workshop_vpc" {
  vpc_name   = "${var.project_name}-vpc"
  cidr_block = var.vpc_cidr
  tags = {
    Name        = "${var.project_name}-vpc"
    Environment = "workshop"
  }
}

resource "alicloud_vswitch" "workshop_vswitch" {
  vswitch_name = "${var.project_name}-vswitch"
  vpc_id       = alicloud_vpc.workshop_vpc.id
  cidr_block   = var.vswitch_cidr
  zone_id      = data.alicloud_zones.default.zones[0].id
  tags = {
    Name        = "${var.project_name}-vswitch"
    Environment = "workshop"
  }
}

# ============================================================================
# Security Group
# ============================================================================

resource "alicloud_security_group" "workshop_sg" {
  security_group_name = "${var.project_name}-sg"
  description         = "Security group for workshop ECS instance"
  vpc_id              = alicloud_vpc.workshop_vpc.id
  tags = {
    Name        = "${var.project_name}-sg"
    Environment = "workshop"
  }
}

# Allow HTTP traffic on port 80 from allowed IP only
resource "alicloud_security_group_rule" "allow_http" {
  type              = "ingress"
  ip_protocol       = "tcp"
  nic_type          = "intranet"
  policy            = "accept"
  port_range        = "80/80"
  priority          = 1
  security_group_id = alicloud_security_group.workshop_sg.id
  cidr_ip           = var.allowed_ip
  description       = "Allow HTTP traffic from allowed IP"
}

# Allow SSH traffic on port 22 from allowed IP only (for management)
resource "alicloud_security_group_rule" "allow_ssh" {
  type              = "ingress"
  ip_protocol       = "tcp"
  nic_type          = "intranet"
  policy            = "accept"
  port_range        = "22/22"
  priority          = 1
  security_group_id = alicloud_security_group.workshop_sg.id
  cidr_ip           = var.allowed_ip
  description       = "Allow SSH traffic from allowed IP"
}

# Allow all outbound traffic
resource "alicloud_security_group_rule" "allow_all_outbound" {
  type              = "egress"
  ip_protocol       = "all"
  nic_type          = "intranet"
  policy            = "accept"
  port_range        = "-1/-1"
  priority          = 1
  security_group_id = alicloud_security_group.workshop_sg.id
  cidr_ip           = "0.0.0.0/0"
  description       = "Allow all outbound traffic"
}

# ============================================================================
# ECS Instance
# ============================================================================

resource "alicloud_instance" "workshop_ecs" {
  instance_name   = "${var.project_name}-ecs"
  instance_type   = var.instance_type
  image_id        = "ubuntu_24_04_x64_20G_alibase_20251126.vhd"
  security_groups = [alicloud_security_group.workshop_sg.id]
  vswitch_id      = alicloud_vswitch.workshop_vswitch.id

  # System disk configuration
  system_disk_category = "cloud_essd"
  system_disk_size     = 40

  # Allocate public IP
  internet_max_bandwidth_out = 10
  internet_charge_type       = "PayByTraffic"

  # User data script to install and start Nginx
  user_data = base64encode(<<-EOF
    #!/bin/bash
    # Update package lists
    apt-get update -y
    
    # Install Nginx
    apt-get install -y nginx
    
    # Create a custom welcome page
    cat > /var/www/html/index.html << 'HTMLEOF'
    <!DOCTYPE html>
    <html>
    <head>
        <title>Alibaba Cloud Terraform Workshop</title>
        <style>
            body {
                font-family: Arial, sans-serif;
                display: flex;
                justify-content: center;
                align-items: center;
                height: 100vh;
                margin: 0;
                background: linear-gradient(135deg, #FF6A00 0%, #FF8C00 100%);
                color: white;
            }
            .container {
                text-align: center;
                padding: 40px;
                background: rgba(0, 0, 0, 0.2);
                border-radius: 15px;
                box-shadow: 0 8px 32px rgba(0, 0, 0, 0.3);
            }
            h1 {
                font-size: 2.5em;
                margin-bottom: 20px;
            }
            p {
                font-size: 1.2em;
            }
            .success {
                color: #90EE90;
                font-weight: bold;
                font-size: 1.5em;
            }
        </style>
    </head>
    <body>
        <div class="container">
            <h1>Alibaba Cloud Terraform Workshop</h1>
            <p class="success">Deployment Successful!</p>
            <p>Congratulations! Your ECS instance is running Nginx.</p>
        </div>
    </body>
    </html>
    HTMLEOF
    
    # Enable and start Nginx
    systemctl enable nginx
    systemctl start nginx
    EOF
  )

  tags = {
    Name        = "${var.project_name}-ecs"
    Environment = "workshop"
  }
}
