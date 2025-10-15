locals {
  subnets = data.terraform_remote_state.network.outputs.subnets
  sg      = data.terraform_remote_state.network.outputs.sg
  efs     = data.terraform_remote_state.storage.outputs.efs
  ecr     = data.terraform_remote_state.storage.outputs.ecr
  alb     = data.terraform_remote_state.compute.outputs.alb
  asg     = data.terraform_remote_state.compute.outputs.asg
}

module "ecs_cluster" {
  source       = "../../../modules/ecs/ecs-cluster"
  project_name = var.project_name
  environment  = var.environment

  auto_scaling_groups = {
    jenkins = {
      name            = "jenkins"
      arn             = local.asg["jenkins"].arn
      target_capacity = 90
    }
    backend = {
      name            = "backend"
      arn             = local.asg["backend"].arn
      target_capacity = 90
    }
    frontend = {
      name            = "frontend"
      arn             = local.asg["frontend"].arn
      target_capacity = 90
    }
  }
}

module "jenkins_service" {
  source                 = "../../../modules/ecs/ecs-service"
  project_name           = var.project_name
  environment            = var.environment
  capacity_provider_name = module.ecs_cluster.asg_cp["jenkins"].name
  name                   = "jenkins"
  ecs_cluster_id         = module.ecs_cluster.id
  ecs_cluster_name       = module.ecs_cluster.name
  desired_count          = 1
  subnet_ids             = local.subnets["frontend"]
  security_groups        = [local.sg["jenkins"]]
  container_port         = 8080
  alb_blue_tg_arn        = local.alb["frontend"]["blue_tg"]["jenkins"].arn
  container_name         = "jenkins"
  task_definition_arn    = module.frontend_task.arn
}

resource "aws_cloudwatch_log_group" "jenkins" {
  name              = "/ecs/jenkins"
  retention_in_days = 7
}

module "frontend_task" {
  source                   = "../../../modules/ecs/ecs-task"
  project_name             = var.project_name
  environment              = var.environment
  family                   = "frontend"
  requires_compatibilities = ["EC2"]
  cpu                      = 1024
  memory                   = 700

  containers = [
    {
      name      = "jenkins"
      cpu       = 1024
      memory    = 700
      image     = "jenkins/jenkins:lts-alpine"
      essential = true

      portMappings = [
        {
          containerPort = 8080
          hostPort      = 8080
          protocol      = "tcp"
        }
      ]

      mountPoints = [
        {
          sourceVolume  = "jenkins_efs"
          containerPath = "/var/jenkins_home"
          readOnly      = false
        }
      ]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = "/ecs/jenkins"
          "awslogs-region"        = var.region
          "awslogs-stream-prefix" = "ecs"
        }
      }

      healthCheck = {
        command     = ["CMD", "curl", "-f", "http://localhost:8080/login"]
        interval    = 200
        timeout     = 5
        retries     = 3
        startPeriod = 300
      }
    }
  ]

  volumes = [
    {
      name = "jenkins_efs"
      efs_volume_configuration = {
        file_system_id     = local.efs["jenkins"].id
        transit_encryption = "ENABLED"
        authorization_config = {
          access_point_id = local.efs["jenkins"].access_points["jenkins"].id
          iam             = "DISABLED"
        }
      }
    }
  ]
}

module "frontend_codedeploy" {
  source                  = "../../../modules/codedeploy"
  name                    = "frontend"
  project_name            = var.project_name
  environment             = var.environment
  ecs_cluster_name        = module.ecs_cluster.name
  ecs_service_name        = module.frontend_service.name
  listener_arn            = local.alb["frontend"].listener_arn
  blue_target_group_name  = local.alb["frontend"]["blue_tg"]["web"].name
  green_target_group_name = local.alb["frontend"]["green_tg"]["web"].name
}


module "backend_codedeploy" {
  source                  = "../../../modules/codedeploy"
  name                    = "backend"
  project_name            = var.project_name
  environment             = var.environment
  ecs_cluster_name        = module.ecs_cluster.name
  ecs_service_name        = module.backend_service.name
  listener_arn            = local.alb["frontend"].listener_arn
  blue_target_group_name  = local.alb["frontend"]["blue_tg"]["api"].name
  green_target_group_name = local.alb["frontend"]["green_tg"]["api"].name
}



module "backend_service" {
  source                 = "../../../modules/ecs/ecs-service"
  project_name           = var.project_name
  environment            = var.environment
  capacity_provider_name = module.ecs_cluster.asg_cp["backend"].name
  name                   = "backend"
  ecs_cluster_id         = module.ecs_cluster.id
  ecs_cluster_name       = module.ecs_cluster.name
  desired_count          = 1
  subnet_ids             = local.subnets["backend"]
  security_groups        = [local.sg["backend"]]
  container_port         = 80
  alb_blue_tg_arn        = local.alb["frontend"]["blue_tg"]["api"].arn
  container_name         = "backend"
  task_definition_arn    = module.backend_task.arn
}

resource "aws_cloudwatch_log_group" "backend" {
  name              = "/ecs/backend"
  retention_in_days = 7
}

module "backend_task" {
  source                   = "../../../modules/ecs/ecs-task"
  project_name             = var.project_name
  environment              = var.environment
  family                   = "backend"
  requires_compatibilities = ["EC2"]
  cpu                      = 1024
  memory                   = 700

  containers = [
    {
      name      = "backend"
      cpu       = 1024
      memory    = 700
      image     = local.ecr["backend"].url
      essential = true

      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
          protocol      = "tcp"
        }
      ]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = "/ecs/backend"
          "awslogs-region"        = var.region
          "awslogs-stream-prefix" = "ecs"
        }
      }
    }
  ]
}










module "frontend_service" {
  source                 = "../../../modules/ecs/ecs-service"
  project_name           = var.project_name
  environment            = var.environment
  capacity_provider_name = module.ecs_cluster.asg_cp["frontend"].name
  name                   = "frontend"
  ecs_cluster_id         = module.ecs_cluster.id
  ecs_cluster_name       = module.ecs_cluster.name
  desired_count          = 1
  subnet_ids             = local.subnets["frontend"]
  security_groups        = [local.sg["frontend"]]
  container_port         = 80
  alb_blue_tg_arn        = local.alb["frontend"]["blue_tg"]["web"].arn
  container_name         = "frontend"
  task_definition_arn    = module.frontend_task.arn
}

resource "aws_cloudwatch_log_group" "frontend" {
  name              = "/ecs/frontend"
  retention_in_days = 7
}

module "frontend_task" {
  source                   = "../../../modules/ecs/ecs-task"
  project_name             = var.project_name
  environment              = var.environment
  family                   = "frontend"
  requires_compatibilities = ["EC2"]
  cpu                      = 1024
  memory                   = 700

  containers = [
    {
      name      = "frontend"
      cpu       = 1024
      memory    = 700
      image     = local.ecr["frontend"].url
      essential = true

      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
          protocol      = "tcp"
        }
      ]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = "/ecs/frontend"
          "awslogs-region"        = var.region
          "awslogs-stream-prefix" = "ecs"
        }
      }
    }
  ]
}