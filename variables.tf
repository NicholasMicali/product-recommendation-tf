variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-west-2"
}

variable "project_name" {
  description = "Name of the project"
  type        = string
  default     = "product-recommendation"
}

variable "environment" {
  description = "Environment (dev/staging/production)"
  type        = string
  default     = "dev"
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)
  default     = ["us-west-2a", "us-west-2b", "us-west-2c"]
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
  default     = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
}

variable "recommendation_engine_image" {
  description = "Docker image for recommendation engine"
  type        = string
}

variable "ecs_min_capacity" {
  description = "Minimum number of ECS tasks"
  type        = number
  default     = 2
}

variable "ecs_max_capacity" {
  description = "Maximum number of ECS tasks"
  type        = number
  default     = 10
}

variable "database_name" {
  description = "Name of the database"
  type        = string
  default     = "recommendationdb"
}

variable "database_username" {
  description = "Master username for the database"
  type        = string
  default     = "dbadmin"
}

variable "sagemaker_model_image" {
  description = "Docker image for SageMaker model"
  type        = string
}

variable "model_artifact_path" {
  description = "S3 path to model artifacts"
  type        = string
}

variable "sagemaker_instance_type" {
  description = "Instance type for SageMaker endpoint"
  type        = string
  default     = "ml.t2.medium"
}
