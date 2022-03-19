output "EC2_Webserver_external_IP" {
  value       = aws_instance.web.public_ip
}

output "Webserver_security_groups_id" {
  value       = aws_security_group.web_access.id
}

output "rds_hostname" {
  description = "RDS instance hostname"
  value       = aws_db_instance.education.address
}

output "rds_port" {
  description = "RDS instance port"
  value       = aws_db_instance.education.port
}