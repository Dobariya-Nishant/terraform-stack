output "secrets" {
  value = {
    for key, secret in aws_secretsmanager_secret.this :
    key => secret.arn
  }
}

output "secret_arns" {
  description = "List of secret ARNs created in this module"
  value       = [for s in aws_secretsmanager_secret.this : s.arn]
}