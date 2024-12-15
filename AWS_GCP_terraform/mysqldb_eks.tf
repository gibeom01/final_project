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
    subnet_ids            = [aws_subnet.PRI-RDS-2A.id, aws_subnet.PRI-RDS-2C.id]
    security_group_ids    = [aws_security_group.PRI-RDS-SG.id]
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
  node_group_name   = "mysqldb_node_group"
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
    Name      = "mysqldb_node_group"
    Env       = "prod"
    Team      = "DBOps"
    App       = "mysqldb"
    "k8s.io/cluster-autoscaler/enabled"                   = "true"
    "k8s.io/cluster-autoscaler/${var.cluster_name[0]}"    = "true"
  }
}

resource "null_resource" "install_helm_mysqldb" {
  provisioner "local-exec" {
    command = <<-EOT
      echo "Downloading Helm install script..."
      curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3

      echo "Configuring AWS CLI..."
      sudo -u ubuntu aws configure set aws_access_key_id "AKIAQR5EPRGQEV6ZGXOU"
      sudo -u ubuntu aws configure set aws_secret_access_key "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"
      sudo -u ubuntu aws configure set default.region "ap-northeast-2"
      sudo -u ubuntu aws configure set default.output "json"

      echo "Making the Helm install script executable..."
      sudo chmod +x ./helm/get_helm.sh

      echo "Installing Helm..."
      ./helm/get_helm.sh

      echo "Updating kubeconfig for EKS cluster..."
      aws eks update-kubeconfig --region ap-northeast-2 --name mysqldb

      echo "Deploying Helm chart..."
      helm upgrade --install mysqldb-release ./helm/mysqldb --namespace database --create-namespace

      echo "Helm installation and deployment completed successfully!"
    EOT

    environment = {
      AWS_PROFILE = "default"
      KUBECONFIG  = "/home/ubuntu/.kube/config"
      HOME        = "/home/ubuntu"
    }

    working_dir = "${path.module}/helm"
  }

  depends_on = [
    aws_eks_cluster.mysqldb_cluster
  ]
}
