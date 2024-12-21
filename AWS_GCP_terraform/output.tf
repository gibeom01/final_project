output "security_group_mysql" {
  value       = aws_security_group.PRI-RDS-SG.id
  description = "The security group for MySQL"
  depends_on = [var.pri_rds_sg]
}

output "security_group_tomcat" {
  value       = aws_security_group.PRI-SG.id
  description = "The security group for Tomcat"
  depends_on = [var.pri_sg]
}

output "public_ip" {
  value       = aws_instance.bastion_host.public_ip
  description = "The public IPs of the Bastion instance"
}

output "public_dns" {
  value       = aws_instance.bastion_host.public_dns
  description = "The public DNS names of the Bastion Instance"
}

output "private_ip" {
  value       = aws_instance.bastion_host.private_ip
  description = "The private IPs of the Bastion Instance"
}

output "ssh_tunnel_command" {
  value = <<EOF
ssh -i ${aws_key_pair.aws_project.key_name}.pem -L 8080:${aws_instance.bastion_host.public_ip} -L 8081:${aws_instance.bastion_host.private_ip}:8080
EOF
  description = "SSH Tunnel command to access the Bastion Host"
}

output "mysqldb_alarm_arn" {
  value = aws_sns_topic.mysqldb_sns.arn
}

output "tomcatwas_alarm_arn" {
  value = aws_sns_topic.tomcatwas_sns.arn
}
