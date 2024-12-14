resource "aws_instance" "bastion_host" {
  ami                    = "ami-042e76978adeb8c48"
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.PUB-2A.id
  key_name               = aws_key_pair.aws_project.key_name
  source_dest_check      = false
  security_groups        = [aws_security_group.PUB-SG.id]

  user_data = templatefile("${path.module}/user_data_aws_bastion.sh", {
    private_key = local.encoded_private_key
  })
  
  tags = {
    Name = var.ec2_name
  }
}
