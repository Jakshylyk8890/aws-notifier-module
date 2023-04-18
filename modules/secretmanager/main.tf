resource "aws_secretsmanager_secret" "secret-manager" {
  name                    = var.secretmanager_name
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "secret_version" {
  secret_id = aws_secretsmanager_secret.secret-manager.id
  secret_string = jsonencode({
    "username" = var.user_name
    "password" = var.user_password
  })
}
