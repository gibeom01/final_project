data "aws_caller_identity" "current" {}

locals {
  mysql_node_group_name  = "${var.cluster_name[0]}-node-group"
  tomcat_node_group_name = "${var.cluster_name[1]}-node-group"
  iam_role_policy_prefix = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:policy"
}

resource "aws_eks_cluster" "mysqldb_cluster" {
  name     = var.cluster_name[0]
  version  = var.cluster_version
  role_arn = aws_iam_role.aws_eks_role.arn

  vpc_config {
    subnet_ids = [aws_subnet.PRI-RDS-2A.id, aws_subnet.PRI-RDS-2C.id]
    security_group_ids = [
      aws_security_group.PRI-RDS-SG.id
    ]

    endpoint_private_access = true
    endpoint_public_access  = false
  }
}

resource "aws_launch_template" "mysqldb_node_group_template" {
  name_prefix   = "${var.cluster_name[0]}-launch-template"
  instance_type = "t2.micro"

  network_interfaces {
    security_groups = [
      aws_security_group.PRI-RDS-SG.id
    ]
  }

  lifecycle {
    create_before_destroy = true
  }

  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size = 50
      volume_type = "gp3"
    }
  }
}

resource "aws_eks_node_group" "mysqldb_node_group" {
  cluster_name      = aws_eks_cluster.mysqldb_cluster.name
  node_group_name   = local.mysql_node_group_name
  node_role_arn     = aws_iam_role.aws_eks_role.arn
  subnet_ids        = [aws_subnet.PRI-RDS-2A.id, aws_subnet.PRI-RDS-2C.id]
  capacity_type     = "ON_DEMAND"

  scaling_config {
    desired_size = 3
    min_size     = 2
    max_size     = 4
  }

  update_config {
    max_unavailable = 1
  }

  launch_template {
    id      = aws_launch_template.mysqldb_node_group_template.id
    version = "$Latest"
  }

  labels = {
    ondemand = "true"
  }

  tags = {
    Name      = local.mysql_node_group_name
    Env       = "prod"
    Team      = "DBOps"
    App       = "mysqldb"
    "k8s.io/cluster-autoscaler/enabled"                   = "true"
    "k8s.io/cluster-autoscaler/${var.cluster_name[0]}"    = "true"
  }
}

resource "aws_eks_cluster" "tomcatwas_cluster" {
  name     = var.cluster_name[1]
  version  = var.cluster_version
  role_arn = aws_iam_role.aws_eks_role.arn

  vpc_config {
    subnet_ids = [aws_subnet.PRI-2A.id, aws_subnet.PRI-2C.id]
    security_group_ids = [
      aws_security_group.PRI-SG.id
    ]
    
    endpoint_private_access = true
    endpoint_public_access  = false
  }
}

resource "aws_launch_template" "tomcatwas_node_group_template" {
  name_prefix   = "${var.cluster_name[1]}-launch-template"
  instance_type = "t2.micro"

  network_interfaces {
    security_groups = [
      aws_security_group.PRI-SG.id
    ]
  }

  lifecycle {
    create_before_destroy = true
  }

    block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size = 50
      volume_type = "gp3"
    }
  }
}

resource "aws_eks_node_group" "tomcatwas_node_group" {
  cluster_name      = aws_eks_cluster.tomcatwas_cluster.name
  node_group_name   = local.tomcat_node_group_name
  node_role_arn     = aws_iam_role.aws_eks_role.arn
  subnet_ids        = [aws_subnet.PRI-2A.id, aws_subnet.PRI-2C.id]
  capacity_type     = "ON_DEMAND"

  scaling_config {
    desired_size = 3
    min_size     = 2
    max_size     = 4
  }

  update_config {
    max_unavailable = 1
  }

  launch_template {
    id      = aws_launch_template.tomcatwas_node_group_template.id
    version = "$Latest"
  }

  labels = {
    ondemand = "true"
  }

  tags = {
    Name  = local.tomcat_node_group_name
    Env   = "prod"
    Team  = "DBOps"
    App   = "tomcatwas"
    "kubernetes.io/cluster/${var.cluster_name[1]}" = "owned"
  }
}

resource "null_resource" "install_helm_aws" {
  provisioner "local-exec" {
    command = <<-EOT
      curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
      chmod +x get_helm.sh
      ./get_helm.sh
      # Ensure /usr/local/bin is in the PATH
      echo "export PATH=\$PATH:/usr/local/bin" >> ~/.bashrc
      source ~/.bashrc
    EOT

    environment = {
      HOME = "/home/ubuntu"
    }
  }
}

resource "null_resource" "apply_mysqldb_yaml" {
  provisioner "local-exec" {
    command = <<-EOT
      aws eks update-kubeconfig --region ap-northeast-2 --name mysqldb
      helm upgrade --install mysqldb ./mysqldb-deployment.yaml
    EOT
  }

  depends_on = [aws_eks_cluster.mysqldb_cluster]
}

resource "null_resource" "apply_tomcatdb_yaml" {
  provisioner "local-exec" {
    command = <<-EOT
      aws eks update-kubeconfig --region ap-northeast-2 --name tomcatwas
      helm upgrade --install tomcatwas ./tomcatwas-deployment.yaml
    EOT
  }

  depends_on = [aws_eks_cluster.tomcatwas_cluster]
}
