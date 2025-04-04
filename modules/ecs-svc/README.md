# ECS Service Module

This module creates an Amazon ECS Service for deploying containerized applications with auto-scaling capabilities.

## Features

- Fargate launch type for serverless container deployment
- Auto-scaling based on CPU and Memory utilization
- Task definition with customizable CPU and Memory allocation
- Network configuration with VPC support

## Usage

```hcl
module "ecs_service" {
  source = "./modules/ecs-svc"

  cluster_arn     = "arn:aws:ecs:region:account:cluster/name"
  container_image = "my-recommendation-engine:latest"
  environment     = "production"
  subnet_ids      = ["subnet-1", "subnet-2"]

  min_capacity = 2
  max_capacity = 10

  tags = {
    Environment = "production"
    Project     = "recommendation-engine"
  }
}
```

## Requirements

| Name | Version |
|------|----------|
| terraform | >= 1.0 |
| aws | >= 4.66.1 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| cluster_arn | ARN of the ECS cluster | `string` | n/a | yes |
| container_image | Container image for the recommendation engine | `string` | n/a | yes |
| environment | Environment name | `string` | n/a | yes |
| min_capacity | Minimum number of tasks | `number` | `1` | no |
| max_capacity | Maximum number of tasks | `number` | `10` | no |
| subnet_ids | List of subnet IDs for the ECS tasks | `list(string)` | n/a | yes |
| tags | A map of tags to add to all resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| service_id | ARN that identifies the service |
| service_name | Name of the service |
| task_definition_arn | Full ARN of the Task Definition |
| security_group_id | ID of the security group |