output "efs" {
  value = {
    jenkins = {
      id            = module.jenkins_efs.id
      name          = module.jenkins_efs.name
      arn           = module.jenkins_efs.arn
      access_points = module.jenkins_efs.access_points
    }
  }
}

output "ecr" {
  value = {
    frontend = {
      arn = module.frontend.arn
      url = module.frontend.repository_url
    }
    backend = {
      arn = module.backend.arn
      url = module.backend.repository_url
    }
  }
}