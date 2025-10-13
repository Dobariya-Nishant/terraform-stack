output "alb" {
  value = {
    frontend = {
      id           = module.frontend_alb.id
      listener_arn = module.frontend_alb.listener_arn
      blue_tg      = module.frontend_alb.blue_tg
      green_tg     = module.frontend_alb.green_tg
    }
  }
}

output "asg" {
  value = {
    jenkins = {
      id   = module.jenkins_asg.id
      name = module.jenkins_asg.name
      arn  = module.jenkins_asg.arn
    }
    frontend = {
      id   = module.frontend_asg.id
      name = module.frontend_asg.name
      arn  = module.frontend_asg.arn
    }
    backend = {
      id   = module.backend_asg.id
      name = module.backend_asg.name
      arn  = module.backend_asg.arn
    }
  }
}

output "ec2" {
  value = {
    bastion = {
      id  = module.bastion_ec2.id
      arn = module.bastion_ec2.arn
    }
  }
}