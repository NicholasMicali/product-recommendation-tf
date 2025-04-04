# RDS Module

This module provisions a production-grade AWS RDS instance with the following features:

- PostgreSQL 15.3 database engine
- Multi-AZ deployment for high availability
- Automated backups with 7-day retention
- Enhanced monitoring enabled
- Performance Insights enabled
- Storage encryption enabled
- Deletion protection enabled

## Usage

```hcl
module "rds" {
  source = "./modules/rds"

  identifier = "production-db"
  db_name    = "appdb"
  username   = "dbadmin"

  vpc_security_group_ids = ["sg-12345678"]
  db_subnet_group_name   = "my-db-subnet-group"

  tags = {
    Environment = "production"
    Project     = "myapp"
  }
}
```

## Requirements

| Name | Version |
|------|----------|
| terraform | >= 1.0 |
| aws | >= 5.62 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| identifier | The name of the RDS instance | `string` | n/a | yes |
| db_name | The name of the database to create | `string` | n/a | yes |
| username | Username for the master DB user | `string` | n/a | yes |
| vpc_security_group_ids | List of VPC security groups to associate | `list(string)` | `[]` | no |
| db_subnet_group_name | Name of DB subnet group | `string` | n/a | yes |
| create_monitoring_role | Create IAM role for enhanced monitoring | `bool` | `true` | no |
| tags | A mapping of tags to assign to all resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| db_instance_endpoint | The connection endpoint |
| db_instance_arn | The ARN of the RDS instance |
| db_instance_name | The database name |
| db_instance_username | The master username for the database |
