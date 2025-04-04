# Configure AWS Provider
provider "aws" {
  region = var.aws_region
}

# VPC Configuration
module "vpc" {
  source = "./modules/vpc"

  name = "${var.project_name}-vpc"
  cidr = var.vpc_cidr

  azs             = var.availability_zones
  private_subnets = var.private_subnet_cidrs
  public_subnets  = var.public_subnet_cidrs

  enable_nat_gateway   = true
  single_nat_gateway   = var.environment != "production"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = local.common_tags
}

# ECS Service Configuration
module "recommendation_service" {
  source = "./modules/ecs-svc"

  cluster_arn     = aws_ecs_cluster.main.arn
  container_image = var.recommendation_engine_image
  environment     = var.environment
  subnet_ids      = module.vpc.private_subnets
  min_capacity    = var.ecs_min_capacity
  max_capacity    = var.ecs_max_capacity

  tags = local.common_tags
}

# RDS Configuration
module "database" {
  source = "./modules/rds"

  identifier = "${var.project_name}-db"
  db_name    = var.database_name
  username   = var.database_username

  vpc_security_group_ids = [aws_security_group.rds.id]
  db_subnet_group_name   = aws_db_subnet_group.main.name

  tags = local.common_tags
}

# SageMaker Resources
resource "aws_sagemaker_model" "recommendation_model" {
  name               = "${var.project_name}-model"
  execution_role_arn = aws_iam_role.sagemaker_execution_role.arn

  primary_container {
    image = var.sagemaker_model_image
    model_data_url = var.model_artifact_path
  }

  tags = local.common_tags
}

resource "aws_sagemaker_endpoint_configuration" "recommendation" {
  name = "${var.project_name}-endpoint-config"

  production_variants {
    variant_name           = "default"
    model_name             = aws_sagemaker_model.recommendation_model.name
    instance_type          = var.sagemaker_instance_type
    initial_instance_count = 1
  }

  tags = local.common_tags
}

resource "aws_sagemaker_endpoint" "recommendation" {
  name                 = "${var.project_name}-endpoint"
  endpoint_config_name = aws_sagemaker_endpoint_configuration.recommendation.name

  tags = local.common_tags
}

# EventBridge Rule
resource "aws_cloudwatch_event_rule" "recommendation_events" {
  name        = "${var.project_name}-events"
  description = "Capture recommendation engine events"

  event_pattern = jsonencode({
    source      = ["${var.project_name}.recommendations"]
    detail_type = ["UserActivity", "ProductPurchase"]
  })

  tags = local.common_tags
}

# Lambda Function for Email Notifications
resource "aws_lambda_function" "email_notification" {
  filename         = "${path.module}/email_notification.zip"
  function_name    = "${var.project_name}-email-notification"
  role             = aws_iam_role.lambda_execution_role.arn
  handler          = "index.handler"
  runtime          = "nodejs18.x"
  timeout          = 30

  environment {
    variables = {
      ENVIRONMENT = var.environment
    }
  }

  tags = local.common_tags
}

# Local Variables
locals {
  common_tags = {
    Environment = var.environment
    Project     = var.project_name
    Terraform   = "true"
  }
}
