output "instance_profile" {
  value = aws_iam_instance_profile.worker.name
}

output "master_arn" {
  value = aws_iam_role.master.arn
}

output "worker_arn" {
  value = aws_iam_role.worker.arn
}
