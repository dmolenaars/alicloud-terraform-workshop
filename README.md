# Alibaba Cloud Terraform Workshop

This Terraform project deploys a basic infrastructure on Alibaba Cloud, including a VPC, VSwitch, Security Group, and an ECS instance running Nginx.

## Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                         VPC (10.0.0.0/16)                   │
│  ┌───────────────────────────────────────────────────────┐  │
│  │                  VSwitch (10.0.1.0/24)                │  │
│  │  ┌─────────────────────────────────────────────────┐  │  │
│  │  │              ECS Instance                       │  │  │
│  │  │              Running Nginx                      │  │  │
│  │  │              Public IP: <assigned>              │  │  │
│  │  └─────────────────────────────────────────────────┘  │  │
│  └───────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────┘
                              │
                    Security Group Rules:
                    - Inbound: Port 80 (HTTP)
                    - Inbound: Port 22 (SSH)
                    - Outbound: All traffic
```

## Prerequisites

1. **Alibaba Cloud Account**: You need an Alibaba Cloud account with sufficient permissions.

2. **Alibaba Cloud CLI or Environment Variables**: Configure your credentials using one of these methods:

   **Option A: Environment Variables**
   ```bash
   export ALIBABA_CLOUD_ACCESS_KEY_ID="your-access-key"
   export ALIBABA_CLOUD_ACCESS_KEY_SECRET=="your-secret-key"
   export ALIBABA_CLOUD_REGION="eu-west-1"
   ```

   **Option B: Alibaba Cloud CLI**
   ```bash
   aliyun configure
   ```

3. **Terraform**: Install Terraform version 1.0.0 or later.
   ```bash
   # macOS with Homebrew
   brew install terraform
   
   # Or download from https://www.terraform.io/downloads
   ```

## Quick Start

1. **Clone or navigate to this directory**
   ```bash
   cd alicloud-terraform-workshop
   ```

2. **Initialize Terraform**
   ```bash
   terraform init
   ```

3. **Review the execution plan**
   ```bash
   terraform plan
   ```

4. **Apply the configuration**
   ```bash
   terraform apply
   ```

5. **Verify your deployment**
   
   After the deployment completes, Terraform will output the public IP address. Open your browser and navigate to:
   ```
   http://<ecs_public_ip>
   ```
   
   You should see a welcome page confirming your deployment was successful!

## Outputs

| Output | Description |
|--------|-------------|
| `ecs_public_ip` | Public IP address of the ECS instance |
| `nginx_url` | URL to access the Nginx web server |
| `ecs_instance_id` | ID of the ECS instance |
| `vpc_id` | ID of the VPC |
| `vswitch_id` | ID of the VSwitch |
| `security_group_id` | ID of the Security Group |

## Clean Up

To destroy all resources created by this project:

```bash
terraform destroy
```

## Files Structure

```
alicloud-terraform-workshop/
├── main.tf                    # Main Terraform configuration
├── variables.tf               # Variable definitions
├── outputs.tf                 # Output definitions
├── terraform.tfvars.example   # Example variables file
├── .gitignore                 # Git ignore file
└── README.md                  # This file
```

## Workshop Tasks

### Task 1: Basic Deployment
Deploy the infrastructure as-is and verify Nginx is accessible.

### Task 2: Customize the Instance
Modify the ECS instance type or disk size in `variables.tf`.

### Task 3: Add More Security Rules
Add additional security group rules for HTTPS (port 443).

### Task 4: Multiple Instances
Modify the configuration to deploy multiple ECS instances.

## Troubleshooting

### Common Issues

1. **Instance type not available**: Not all instance types are available in every region. Check if the instance type is available at https://www.alibabacloud.com/en/product/ecs-pricing-list/en

2. **Insufficient permissions**: Ensure your Alibaba Cloud credentials have permissions to create VPC, ECS, and Security Group resources.

3. **Nginx not responding**: Wait a minute after deployment for the user-data script to complete installing and starting Nginx.

## Resources

- [Alibaba Cloud Terraform Provider Documentation](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs)
- [Alibaba Cloud ECS Documentation](https://www.alibabacloud.com/help/ecs)
