resource "aws_lb" "mysqldb_nlb" {
  name               = "mysqldb-nlb"
  internal           = false
  load_balancer_type = "network"
  security_groups    = [aws_security_group.PUB-SG.id]
  subnets            = [
    aws_subnet.PUB-2A.id,
    aws_subnet.PUB-2C.id
  ]

  enable_deletion_protection = false
  enable_cross_zone_load_balancing = true

  tags = {
    Name = "mysqldb-nlb"
  }
}

resource "aws_lb" "tomcatwas_nlb" {
  name               = "tomcatwas-nlb"
  internal           = false
  load_balancer_type = "network"
  security_groups    = [aws_security_group.PUB-SG.id]
  subnets            = [
    aws_subnet.PUB-2A.id,
    aws_subnet.PUB-2C.id
  ]

  enable_deletion_protection = false
  enable_cross_zone_load_balancing = true

  tags = {
    Name = "tomcatwas-nlb"
  }
}


resource "aws_lb_target_group" "mysqldb_target_group" {
  name     = "mysqldb-target-group"
  port     = 3306
  protocol = "TCP"
  vpc_id   = aws_vpc.SEC-PRD-VPC.id

  health_check {
    interval            = 30
    port                = 3306
    protocol            = "TCP"
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

resource "aws_lb_target_group" "tomcatwas_target_group" {
  name     = "tomcatwas-target-group"
  port     = 8080
  protocol = "TCP"
  vpc_id   = aws_vpc.SEC-PRD-VPC.id

  health_check {
    interval            = 30
    port                = 8080
    protocol            = "TCP"
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

resource "aws_lb_listener" "mysqldb_nlb_listener" {
  load_balancer_arn = aws_lb.mysqldb_nlb.arn
  port              = 3306
  protocol          = "TCP"

  default_action {
    target_group_arn = aws_lb_target_group.mysqldb_target_group.arn
    type             = "forward"
  }
}

resource "aws_lb_listener" "tomcatwas_nlb_listener" {
  load_balancer_arn = aws_lb.tomcatwas_nlb.arn
  port              = 8080
  protocol          = "TCP"

  default_action {
    target_group_arn = aws_lb_target_group.tomcatwas_target_group.arn 
    type             = "forward" 
  }
}
