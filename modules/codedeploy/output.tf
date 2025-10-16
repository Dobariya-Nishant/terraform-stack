

output "id" {
  value = aws_codedeploy_app.this.id
}

output "arn" {
  value = aws_codedeploy_app.this.arn
}

output "appspec_s3_key" {
  value = aws_s3_object.appspec.key
}

output "appspec_s3_name" {
  value = aws_s3_bucket.ecs_appspec_bucket.id
}