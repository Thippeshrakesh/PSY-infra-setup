output "rds_endpoints" {
  value = {
    for tenant, db in aws_db_instance.postgres :
    tenant => db.endpoint
  }
}

output "secret_arns" {
  value = {
    for tenant, secret in aws_secretsmanager_secret.postgres_secret :
    tenant => secret.arn
  }
}