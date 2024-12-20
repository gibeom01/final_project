resource "aws_eks_cluster" "tomcatwas_cluster" {
  name     = var.cluster_name[1]
  version  = var.cluster_version
  role_arn = aws_iam_role.aws_eks_role.arn

  vpc_config {
    subnet_ids = [
      aws_subnet.PRI-2A.id,
      aws_subnet.PRI-2C.id
    ]
    security_group_ids = [
      aws_security_group.PRI-SG.id
    ]

    endpoint_private_access = true
    endpoint_public_access  = false
  }

  tags = {
    Name = "tomcatwas_cluster"
    Env  = "prod"
    Team = "AppOps"
    App  = "tomcatwas"
  }
}

resource "aws_launch_template" "tomcatwas_node_group_template" {
  name_prefix   = "${var.cluster_name[1]}-launch-template"
  instance_type = "t3.medium"

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

  depends_on = [aws_eks_cluster.tomcatwas_cluster]
}

resource "aws_eks_node_group" "tomcatwas_node_group" {
  cluster_name    = aws_eks_cluster.tomcatwas_cluster.name
  node_group_name = "tomcatwas_node_group"
  node_role_arn   = aws_iam_role.aws_eks_role.arn
  subnet_ids      = [
    aws_subnet.PRI-2A.id,
    aws_subnet.PRI-2C.id
  ]
  capacity_type   = "ON_DEMAND"

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
    Name  = "tomcatwas_node_group"
    Env   = "prod"
    Team  = "AppOps"
    App   = "tomcatwas"
    "kubernetes.io/cluster/${var.cluster_name[1]}" = "owned"
  }

  depends_on = [aws_eks_cluster.tomcatwas_cluster]
}
