resource "random_password" "postgres_password" {
  for_each = toset(var.tenants)

  length  = 16
  special = true

  override_special = "!#$%^&*()-_=+[]{}<>?"
}

resource "aws_secretsmanager_secret" "postgres_secret" {
  for_each = toset(var.tenants)

  name = "${var.project_name}/${each.key}/postgres-credentials"

  tags = merge(var.common_tags, {
    Tenant = each.key
  })
}

resource "aws_secretsmanager_secret_version" "postgres_secret_version" {
  for_each  = toset(var.tenants)
  secret_id = aws_secretsmanager_secret.postgres_secret[each.key].id

  secret_string = jsonencode({
    username = "postgres"
    password = random_password.postgres_password[each.key].result
  })
}

resource "aws_security_group" "postgres_sg" {
  name   = "${var.project_name}-postgres-sg"
  vpc_id = var.vpc_id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.common_tags
}

resource "aws_db_subnet_group" "postgres_subnet_group" {
  name       = "${var.project_name}-postgres-subnet-group"
  subnet_ids = var.postgres_subnet_ids

  tags = var.common_tags
}

resource "aws_db_instance" "postgres" {
  for_each = toset(var.tenants)

  identifier         = "${var.project_name}-${each.key}-postgres"
  engine             = var.postgres_engine
  engine_version     = var.postgres_engine_version
  instance_class     = var.postgres_instance_class

  allocated_storage  = var.postgres_allocated_storage
  storage_type       = var.postgres_storage_type

  multi_az           = var.postgres_multi_az
  availability_zone  = var.postgres_multi_az ? null : var.primary_az
  publicly_accessible = var.postgres_publicly_accessible

  db_name  = each.key
  username = "postgres"
  password = random_password.postgres_password[each.key].result

  vpc_security_group_ids = [aws_security_group.postgres_sg.id]
  db_subnet_group_name   = aws_db_subnet_group.postgres_subnet_group.name

  backup_retention_period = var.postgres_backup_retention_period
  deletion_protection     = var.postgres_deletion_protection
  storage_encrypted       = var.postgres_storage_encrypted

  skip_final_snapshot = true
  apply_immediately   = true

  tags = merge(var.common_tags, {
    Tenant = each.key
  })
}