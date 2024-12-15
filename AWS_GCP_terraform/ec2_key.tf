resource "tls_private_key" "aws_private_keypair" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "aws_project" { 
  key_name   = "aws_project-${terraform.workspace}"
  public_key = tls_private_key.aws_private_keypair.public_key_openssh

  lifecycle {
    prevent_destroy = false
  }

  tags = {
    Name = "aws_project"
  }
}

resource "local_file" "gibeom_private_key" {
  content        = tls_private_key.aws_private_keypair.private_key_pem
  filename       = "${path.root}/aws_project.pem"
  file_permission = "0600"

  lifecycle {
    create_before_destroy = true
  }
}

locals {
  encoded_private_key = base64encode(tls_private_key.aws_private_keypair.private_key_pem)
}
