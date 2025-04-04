# AWS VPC Terraform Module

This Terraform module creates a VPC with public and private subnets across multiple availability zones.

## Features

- VPC with custom CIDR block
- Public and private subnets across multiple AZs
- NAT Gateway for private subnet internet access
- DNS support and hostnames enabled
- Highly available architecture

## Usage

```hcl
module "vpc" {
  source = "./modules/vpc"

  name = "my-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["us-west-2a", "us-west-2b", "us-west-2c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  enable_nat_gateway = true
  single_nat_gateway = true

  tags = {
    Environment = "dev"
    Terraform   = "true"
  }
}
```

## Requirements

| Name | Version |
|------|----------|
| terraform | >= 1.0 |
| aws | >= 4.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| name | Name to be used on all the resources as identifier | `string` | n/a | yes |
| cidr | The CIDR block for the VPC | `string` | n/a | yes |
| azs | A list of availability zones names or ids in the region | `list(string)` | n/a | yes |
| private_subnets | A list of private subnets inside the VPC | `list(string)` | n/a | yes |
| public_subnets | A list of public subnets inside the VPC | `list(string)` | n/a | yes |
| enable_nat_gateway | Should be true if you want to provision NAT Gateways | `bool` | `true` | no |
| single_nat_gateway | Should be true if you want to provision a single shared NAT Gateway | `bool` | `true` | no |
| enable_dns_hostnames | Should be true to enable DNS hostnames in the VPC | `bool` | `true` | no |
| enable_dns_support | Should be true to enable DNS support in the VPC | `bool` | `true` | no |
| tags | A map of tags to add to all resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| vpc_id | The ID of the VPC |
| vpc_cidr_block | The CIDR block of the VPC |
| private_subnets | List of IDs of private subnets |
| public_subnets | List of IDs of public subnets |
| nat_public_ips | List of public Elastic IPs created for AWS NAT Gateway |