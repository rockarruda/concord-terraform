output "public_id"  {
  value = aws_instance.main.id
}

output "public_ip"  {
  value = aws_instance.main.public_ip
}

output "private_id" {
  value = aws_instance.main.id
}

output "private_ip" {
  value = aws_instance.main.private_ip
}
