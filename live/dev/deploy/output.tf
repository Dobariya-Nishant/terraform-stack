output "frontend_appspec" {
  value = {
    key = module.frontend_codedeploy.appspec_s3_key
    name = module.frontend_codedeploy.appspec_s3_name
  }
}

output "backend_appspec" {
  value = {
    key = module.backend_codedeploy.appspec_s3_key
    name = module.backend_codedeploy.appspec_s3_name
  }
}