resource "aws_cloudwatch_log_group" "app" {
  name              = "/ecs/${var.project_name}"
  retention_in_days = 7
}

output "log_group_name" {
  value = aws_cloudwatch_log_group.app.name
}