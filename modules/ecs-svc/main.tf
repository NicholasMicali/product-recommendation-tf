module "ecs_service" {
  source = "terraform-aws-modules/ecs/aws//modules/service"

  name        = "product-recommendation-engine"
  cluster_arn = var.cluster_arn

  # Task Definition
  cpu    = 1024
  memory = 4096

  # Container Definition
  container_definitions = {
    recommendation-engine = {
      image = var.container_image
      port_mappings = [
        {
          name          = "recommendation-engine"
          containerPort = 8080
          protocol      = "tcp"
        }
      ]
      environment = [
        {
          name  = "ENV"
          value = var.environment
        }
      ]
    }
  }

  # Auto Scaling
  enable_autoscaling = true
  autoscaling_policies = {
    cpu = {
      policy_type = "TargetTrackingScaling"
      target_tracking_scaling_policy_configuration = {
        predefined_metric_specification = {
          predefined_metric_type = "ECSServiceAverageCPUUtilization"
        }
        target_value = 75
      }
    }
    memory = {
      policy_type = "TargetTrackingScaling"
      target_tracking_scaling_policy_configuration = {
        predefined_metric_specification = {
          predefined_metric_type = "ECSServiceAverageMemoryUtilization"
        }
        target_value = 75
      }
    }
  }

  autoscaling_min_capacity = var.min_capacity
  autoscaling_max_capacity = var.max_capacity

  # Network Configuration
  network_mode = "awsvpc"
  subnet_ids   = var.subnet_ids

  tags = var.tags
}