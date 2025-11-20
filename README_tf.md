# Kamailio Environments Infrastructure

This repository contains Terraform infrastructure-as-code for managing Kamailio
build environments across multiple AWS environments (development and production).
The infrastructure includes VPCs, subnets, security groups, EC2 instances (Jenkins),
and persistent EBS storage with remote state management.

## Architecture Overview

```text
================================================================================
                              AWS ACCOUNT
                           Region: eu-west-1
================================================================================

[STEP 1] GLOBAL INFRASTRUCTURE (environments/global/) - DEPLOY FIRST!
--------------------------------------------------------------------------------

    +-----------------------------------------------------------------------+
    | S3 Bucket: kamailio-build-env-state                                   |
    |   |-- development/terraform.tfstate                                   |
    |   +-- production/terraform.tfstate                                    |
    +-----------------------------------------------------------------------+

    +-----------------------------------------------------------------------+
    | DynamoDB Table: kamailio-build-env-locks                              |
    |   Purpose: State locking for concurrent Terraform operations          |
    +-----------------------------------------------------------------------+


[STEP 2] DEVELOPMENT ENVIRONMENT (environments/development/)
--------------------------------------------------------------------------------

    +-----------------------------------------------------------------------+
    | VPC: kamailio-development-vpc                                         |
    | CIDR: 172.10.0.0/16                                                   |
    |                                                                       |
    |   Availability Zone: eu-west-1b                                       |
    |                                                                       |
    |   +---------------------------------------------------------------+   |
    |   | Subnet: 172.10.10.0/24                                        |   |
    |   +---------------------------------------------------------------+   |
    |                                                                       |
    |   +---------------------------------------------------------------+   |
    |   | Security Group: development-security-group                    |   |
    |   | - Ingress: 80 (HTTP) from 0.0.0.0/0                           |   |
    |   | - Ingress: 443 (HTTPS) from 0.0.0.0/0                         |   |
    |   | - Egress: All traffic                                         |   |
    |   +---------------------------------------------------------------+   |
    |                                                                       |
    |   +---------------------------------------------------------------+   |
    |   | EC2 Instance: Jenkins-development-instance                    |   |
    |   | - AMI: ami-0c9e5f4bbf9701d5d                                  |   |
    |   | - Type: t1.micro                                              |   |
    |   | - Docker: Auto-installed via user_data                        |   |
    |   | - Test Container: traefik/whoami on port 80                   |   |
    |   +---------------------------------------------------------------+   |
    |                     |                                                 |
    |                     | attached to /dev/sdf                            |
    |                     v                                                 |
    |   +---------------------------------------------------------------+   |
    |   | EBS Volume: development-package_volume                        |   |
    |   | - Size: 15 GB                                                 |   |
    |   | - Device: /dev/sdf                                            |   |
    |   | - Mount Point: /mnt/pkg (configurable)                        |   |
    |   | - Lifecycle: prevent_destroy = true                           |   |
    |   +---------------------------------------------------------------+   |
    |                                                                       |
    +-----------------------------------------------------------------------+


[STEP 3] PRODUCTION ENVIRONMENT (environments/production/)
--------------------------------------------------------------------------------

    +-----------------------------------------------------------------------+
    | VPC: kamailio-production-vpc                                          |
    | CIDR: 172.20.0.0/16                                                   |
    |                                                                       |
    |   Availability Zone: eu-west-1b                                       |
    |                                                                       |
    |   +---------------------------------------------------------------+   |
    |   | Subnet: 172.20.20.0/24                                        |   |
    |   +---------------------------------------------------------------+   |
    |                                                                       |
    |   +---------------------------------------------------------------+   |
    |   | Security Group: production-security-group                     |   |
    |   | - Ingress: 80 (HTTP) from 0.0.0.0/0                           |   |
    |   | - Ingress: 443 (HTTPS) from 0.0.0.0/0                         |   |
    |   | - Egress: All traffic                                         |   |
    |   +---------------------------------------------------------------+   |
    |                                                                       |
    |   +---------------------------------------------------------------+   |
    |   | EC2 Instance: Jenkins-production-instance                     |   |
    |   | - AMI: ami-0c9e5f4bbf9701d5d                                  |   |
    |   | - Type: t1.micro                                              |   |
    |   | - Docker: Auto-installed via user_data                        |   |
    |   | - Test Container: traefik/whoami on port 80                   |   |
    |   +---------------------------------------------------------------+   |
    |                     |                                                 |
    |                     | attached to /dev/sdf                            |
    |                     v                                                 |
    |   +---------------------------------------------------------------+   |
    |   | EBS Volume: production-package_volume                         |   |
    |   | - Size: 15 GB                                                 |   |
    |   | - Device: /dev/sdf                                            |   |
    |   | - Mount Point: /mnt/pkg (configurable)                        |   |
    |   | - Lifecycle: prevent_destroy = true                           |   |
    |   +---------------------------------------------------------------+   |
    |                                                                       |
    +-----------------------------------------------------------------------+

================================================================================
```

### Deployment Order

1. **Global** (`environments/global/`) - Creates S3 + DynamoDB for state storage
2. **Development** (`environments/development/`) - Creates dedicated VPC and dev infrastructure
3. **Production** (`environments/production/`) - Creates dedicated VPC and prod infrastructure

### Key Architecture Points

- **Separate VPCs**: Each environment has its own isolated VPC with dedicated CIDR blocks
  - Development: 172.10.0.0/16
  - Production: 172.20.0.0/16
- **Network Isolation**: Development and production are completely isolated from each other by default
- **Consistent Configuration**: Both environments follow the same structure but with different values
- **No Inter-VPC Communication**: The VPCs are not peered. If cross-environment communication
  is needed in the future, VPC peering or Transit Gateway can be configured

## Features

### Remote State Management

- **S3 Backend**: Terraform state files stored remotely in S3 bucket with versioning enabled
- **State Locking**: DynamoDB table prevents concurrent state modifications
- **Encryption**: State files encrypted at rest (AES256)
- **Versioning**: S3 bucket versioning enabled for state recovery
- **Security**: Public access blocked on S3 bucket

### Network Infrastructure

- **Separate VPCs**: Each environment has its own dedicated VPC for complete isolation
  - Development VPC: 172.10.0.0/16
  - Production VPC: 172.20.0.0/16
- **Subnets**: Dedicated subnets per environment with custom CIDR blocks
  - Development Subnet: 172.10.10.0/24
  - Production Subnet: 172.20.20.0/24
- **Security Groups**: Environment-specific security groups with granular rules
  - HTTP (80) and HTTPS (443) ingress from anywhere (0.0.0.0/0)
  - All egress traffic allowed

### Compute Resources

- **EC2 Instances**: Jenkins build servers with configurable instance types
- **Auto-configuration**: User data script installs Docker and test containers
- **SSH Access**: Key-based authentication with configurable key names

### Storage

- **EBS Volumes**: Persistent 15GB storage volumes for build artifacts and packages
- **Auto-attach**: Volumes automatically attached to EC2 instances at `/dev/sdf`
- **Lifecycle Protection**: `prevent_destroy` enabled to protect data from accidental deletion
- **Availability Zone Aware**: Volumes and instances deployed in same AZ (eu-west-1b)

### Environment Isolation

- **Separate VPCs**: Complete network isolation between development and production
- **Availability Zones**: Resources deployed in `eu-west-1b` (configurable)
- **Independent Infrastructure**: Each environment can be managed, updated, and destroyed independently

## Directory Structure

```text
.
├── environments/
│   ├── global/              # Remote state infrastructure (S3 + DynamoDB)
│   ├── development/         # Development environment
│   └── production/          # Production environment
└── modules/
    ├── networking/          # Subnet and networking module
    └── vpc/                 # VPC module
```

## Prerequisites

### AWS Credentials

Configure AWS credentials using one of these methods:

- Use AWS environment variables
- Use AWS CLI profile

### Terraform

- Terraform v1.5+ installed
- AWS Provider v6.0+

### Required IAM Permissions

The Terraform user/role requires the following IAM permissions to deploy this infrastructure:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ec2:*",
        "s3:*",
        "dynamodb:*"
      ],
      "Resource": "*"
    }
  ]
}
```

**Detailed Permissions by Service:**

#### EC2 (Compute & Networking)

- `ec2:CreateVpc`, `ec2:DeleteVpc`, `ec2:DescribeVpcs`, `ec2:ModifyVpcAttribute`
- `ec2:CreateSubnet`, `ec2:DeleteSubnet`, `ec2:DescribeSubnets`
- `ec2:CreateSecurityGroup`, `ec2:DeleteSecurityGroup`, `ec2:DescribeSecurityGroups`
- `ec2:AuthorizeSecurityGroupIngress`, `ec2:AuthorizeSecurityGroupEgress`
- `ec2:RevokeSecurityGroupIngress`, `ec2:RevokeSecurityGroupEgress`
- `ec2:RunInstances`, `ec2:TerminateInstances`, `ec2:DescribeInstances`
- `ec2:CreateVolume`, `ec2:DeleteVolume`, `ec2:DescribeVolumes`
- `ec2:AttachVolume`, `ec2:DetachVolume`
- `ec2:CreateTags`, `ec2:DescribeTags`
- `ec2:DescribeAvailabilityZones`
- `ec2:CreateRouteTable`, `ec2:DeleteRouteTable`, `ec2:DescribeRouteTables`
- `ec2:AssociateRouteTable`, `ec2:DisassociateRouteTable`
- `ec2:CreateRoute`, `ec2:DeleteRoute`
- `ec2:CreateInternetGateway`, `ec2:DeleteInternetGateway`, `ec2:DescribeInternetGateways`
- `ec2:AttachInternetGateway`, `ec2:DetachInternetGateway`

#### S3 (State Storage)

- `s3:CreateBucket`, `s3:DeleteBucket`, `s3:ListBucket`
- `s3:GetObject`, `s3:PutObject`, `s3:DeleteObject`
- `s3:GetBucketVersioning`, `s3:PutBucketVersioning`
- `s3:GetEncryptionConfiguration`, `s3:PutEncryptionConfiguration`
- `s3:GetBucketPublicAccessBlock`, `s3:PutBucketPublicAccessBlock`
- `s3:GetBucketTagging`, `s3:PutBucketTagging`

#### DynamoDB (State Locking)

- `dynamodb:CreateTable`, `dynamodb:DeleteTable`, `dynamodb:DescribeTable`
- `dynamodb:GetItem`, `dynamodb:PutItem`, `dynamodb:DeleteItem`
- `dynamodb:DescribeTimeToLive`, `dynamodb:TagResource`

#### STS (Account Information)

- `sts:GetCallerIdentity`

**Recommended Managed Policies:**

For simplicity in non-production scenarios, you can use these AWS managed policies:

- `AmazonEC2FullAccess`
- `AmazonS3FullAccess`
- `AmazonDynamoDBFullAccess`

**Production Best Practice:**

Create a custom IAM policy with least-privilege permissions scoped to specific resources using tags and resource ARNs.

## Deployment Instructions

### ⚠️ IMPORTANT: Deploy Global Infrastructure First

The global infrastructure **must** be deployed before any environment, as it creates
the S3 bucket and DynamoDB table used for remote state storage.

### Step 1: Deploy Global Infrastructure

```bash
cd environments/global
terraform init
terraform plan
terraform apply
```

**Note the outputs:**

```bash
terraform output
# Outputs:
# - s3_bucket_name
# - dynamodb_table_name
```

### Step 2: Deploy Development Environment

```bash
cd ../development
terraform init
terraform plan
terraform apply
```

### Step 3: Deploy Production Environment

```bash
cd ../production
terraform init
terraform plan
terraform apply
```

## Availability Zones

All resources are deployed in **eu-west-1b** (the second availability zone in eu-west-1). This is configured using:

```hcl
availability_zone = data.aws_availability_zones.available.names[1]
```

**Why Availability Zone Matters:**

- EBS volumes are AZ-specific and can only attach to instances in the same AZ
- Both the EC2 instance and EBS volume must be in the same AZ
- Using `data.aws_availability_zones.available.names[1]` ensures consistency

**To change the availability zone:**

Edit the index value in `ebs-storage.tf` and `ec2-jenkins.tf`:

- `names[0]` = First AZ (eu-west-1a)
- `names[1]` = Second AZ (eu-west-1b)
- `names[2]` = Third AZ (eu-west-1c)

## Storage Protection

### EBS Volume Protection

EBS volumes have **lifecycle protection** enabled to prevent accidental deletion:

```hcl
lifecycle {
  prevent_destroy = true
}
```

This is defined in:

- `environments/development/ebs-storage.tf` (line 10-12)
- `environments/production/ebs-storage.tf` (line 10-12)

### ⚠️ Removing Storage (If Needed)

If you need to destroy the EBS volumes, you must **comment out or remove** the lifecycle block:

**File:** `environments/{environment}/ebs-storage.tf`

```hcl
resource "aws_ebs_volume" "package_volume" {
  availability_zone = data.aws_availability_zones.available.names[1]
  size              = var.packages_disk_volume

  tags = {
    Name        = "${var.environment}-package_volume"
    Environment = "${var.environment}"
  }

  # COMMENT OUT THESE LINES TO ALLOW DELETION:
  # lifecycle {
  #   prevent_destroy = true
  # }
}
```

**Then run:**

```bash
terraform apply  # First apply the lifecycle change
terraform destroy
```

**⚠️ WARNING:** This will permanently delete the EBS volume and all data stored on it. Ensure you have backups before proceeding.

## Configuration Variables

Each environment can be customized via `_variables.tf`:

| Variable | Description | Default |
|----------|-------------|---------|
| `region` | AWS region | `eu-west-1` |
| `availability_zone` | Availability zone for EBS volume | `eu-west-1b` |
| `environment` | Environment name | `development` / `production` |
| `vpc_name` | VPC name | `kamailio-development-vpc` / `kamailio-production-vpc` |
| `main_cidr_block` | VPC network range | `172.10.0.0/16` (dev) / `172.20.0.0/16` (prod) |
| `cidr_block` | Subnet CIDR block | `172.10.10.0/24` (dev) / `172.20.20.0/24` (prod) |
| `packages_disk_volume` | EBS volume size in GB | `15` |
| `ami` | AMI ID for EC2 instance | `ami-0c9e5f4bbf9701d5d` |
| `instance_type` | EC2 instance type | `t1.micro` |
| `initial_ssh_key_name` | SSH key pair name | `aws_ie-1` |

## Outputs

After deployment, each environment outputs:

- `jenkins_instance_public_ip` - Public IP of Jenkins instance
- `jenkins_instance_private_ip` - Private IP of Jenkins instance
- `package_volume_id` - EBS volume ID

## State File Security

- State files are stored in S3 with encryption enabled
- DynamoDB table prevents concurrent modifications
- `.gitignore` excludes local state files and credentials

## Troubleshooting

### EBS Volume Not Visible

If the EBS volume isn't visible at `/dev/sdf`, check for:

- `/dev/xvdf` (most modern instances)
- `/dev/nvme1n1` (Nitro-based instances like t3, m5, c5)

Use `lsblk` to list all block devices.

### State Locking Errors

Ensure the DynamoDB table exists and matches the name in your backend configuration:

```bash
terraform output -state=../global/terraform.tfstate dynamodb_table_name
```

### Availability Zone Errors

Ensure both EBS volume and EC2 instance use the same availability zone configuration.

## Maintenance

### Updating Infrastructure

```bash
terraform plan    # Review changes
terraform apply   # Apply changes
```

### Destroying Infrastructure

```bash
# Remove lifecycle protection from EBS volumes first (see Storage Protection section)
terraform destroy
```

### State Management

```bash
terraform state list                    # List resources
terraform state show <resource>         # Show resource details
terraform refresh                       # Sync state with real infrastructure
```

## License

## Contributors

Ivan Nyarko <kwancro@gmail.com>
