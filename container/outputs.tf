output "service" {
  value = {
    name = aws_ecs_service.main.name
  }
}
