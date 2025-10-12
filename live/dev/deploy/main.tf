locals {
  subnets = data.terraform_remote_state.network.outputs.subnets
  sg      = data.terraform_remote_state.network.outputs.sg
  efs     = data.terraform_remote_state.storage.outputs.efs
  ecr     = data.terraform_remote_state.storage.outputs.ecr
  alb = data.terraform_remote_state.compute.outputs.alb
  asg     = data.terraform_remote_state.compute.outputs.asg
  # ec2     = data.terraform_remote_state.compute.outputs.ec2
}

module "ecs_cluster" {
  source       = "../../../modules/ecs/ecs-cluster"
  project_name = var.project_name
  environment  = var.environment

  auto_scaling_groups = {
    jenkins = {
      name            = "jenkins"
      arn             = local.asg["jenkins"].arn
      target_capacity = 100
    }
  }
}

resource "aws_cloudwatch_log_group" "this" {
  name              = "/ecs/jenkins"
  retention_in_days = 7
}

module "jenkins_service" {
  source                   = "../../../modules/ecs/ecs-service"
  project_name             = var.project_name
  environment              = var.environment
  capacity_provider_name = module.ecs_cluster.asg_cp["jenkins"].name
  name = "jenkins"
  ecs_cluster_id = module.ecs_cluster.id
  ecs_cluster_name = module.ecs_cluster.name
  desired_count = 1
  subnet_ids = local.subnets["frontend"]
  security_groups = [local.sg["jenkins"]]
  container_port = 8080
  alb_blue_tg_arn = local.alb["frontend"]["blue_tg"]["jenkins"].arn
  container_name = "jenkins"
  task_definition_arn =  module.frontend_task.arn
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
      command = ["CMD", "curl", "-f", "http://localhost:8080/login"]
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
        file_system_id = local.efs["jenkins"].id
        transit_encryption = "ENABLED"
        authorization_config = {
          access_point_id = local.efs["jenkins"].access_points["jenkins"].id
          iam             = "DISABLED"
        }
      }
    }
  ]
}




variable "volumes" {
  description = "List of volume configurations for the task."
  type = list(object({
    name      = string
    host_path = optional(string)
    efs_volume_configuration = optional(object({
      file_system_id          = string
      root_directory          = optional(string)
      transit_encryption      = optional(string)
      transit_encryption_port = optional(number)
      authorization_config = object({
        access_point_id = optional(string)
        iam             = optional(string)
      })
    }))
    docker_volume_configuration = optional(object({
      scope         = optional(string)
      autoprovision = optional(bool)
      driver        = optional(string)
      driver_opts   = optional(map(string))
      labels        = optional(map(string))
    }))
  }))
  default = []
}