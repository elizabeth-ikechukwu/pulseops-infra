output "cluster_name" {
  value = aws_ecs_cluster.this.name
}

output "cluster_id" {
  value = aws_ecs_cluster.this.id
}

output "capacity_provider_name" {
  value = aws_ecs_capacity_provider.this.name
}

output "instance_security_group_id" {
  value = aws_security_group.ecs_host.id
}

output "autoscaling_group_name" {
  value = aws_autoscaling_group.ecs.name
}