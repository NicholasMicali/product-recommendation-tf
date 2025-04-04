variable "cluster_arn" {
  description = "ARN of the ECS cluster"
  type        = string
}

variable "container_image" {
  description = "Container image for the recommendation engine"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "min_capacity" {
  description = "Minimum number of tasks"
  type        = number
  default     = 1
}

variable "max_capacity" {
  description = "Maximum number of tasks"
  type        = number
  default     = 10
}

variable "subnet_ids" {
  description = "List of subnet IDs for the ECS tasks"
  type        = list(string)
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}