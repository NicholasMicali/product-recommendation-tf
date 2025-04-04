output "service_id" {
  description = "ARN that identifies the service"
  value       = module.ecs_service.id
}

output "service_name" {
  description = "Name of the service"
  value       = module.ecs_service.name
}

output "task_definition_arn" {
  description = "Full ARN of the Task Definition"
  value       = module.ecs_service.task_definition_arn
}

output "security_group_id" {
  description = "ID of the security group"
  value       = module.ecs_service.security_group_id
}