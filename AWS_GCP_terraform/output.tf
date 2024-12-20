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

output "mysqldb_nlb_arn" {
  value = aws_lb.mysqldb_nlb.arn
}

output "tomcatwas_nlb_arn" {
  value = aws_lb.tomcatwas_nlb.arn
}

output "mysqldb_alarm_arn" {
  value = aws_sns_topic.mysqldb_alerts.arn
}

output "tomcatwas_alarm_arn" {
  value = aws_sns_topic.tomcatwas_alerts.arn
}

output "mysqldb_nlb_listener_arn" {
  value = aws_lb_listener.mysqldb_nlb_listener.arn
}

output "tomcatwas_nlb_listener_arn" {
  value = aws_lb_listener.tomcatwas_nlb_listener.arn
}

output "mysqldb_target_group_arn" {
  value = aws_lb_target_group.mysqldb_target_group.arn
}

output "tomcatwas_target_group_arn" {
  value = aws_lb_target_group.tomcatwas_target_group.arn
}
