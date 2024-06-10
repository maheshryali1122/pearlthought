resource "aws_security_group" "sg_for_ecs" {
    name        = "sgforecs"
    vpc_id      = aws_vpc.myvpc.id

    ingress {
        protocol        = "tcp"
        from_port       = 3000
        to_port         = 3000
        security_groups = [aws_security_group.sg_for_alb.id]
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    depends_on = [
        aws_security_group.sg_for_alb
    ]
}

resource "aws_security_group" "sg_for_alb" {
    name        = "sgforalb"
    vpc_id      = aws_vpc.myvpc.id

    ingress {
        protocol    = "tcp"
        from_port   = 80
        to_port     = 80
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        protocol    = "tcp"
        from_port   = 443
        to_port     = 443
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        protocol    = "tcp"
        from_port   = 3000
        to_port     = 3000
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "Sgforalb"
    }

    depends_on = [
        aws_ecs_cluster.ecs_nodejs
    ]
}

resource "aws_lb" "lb_for_ecs" {
    name               = "lbforecs"
    internal           = false
    load_balancer_type = "application"
    security_groups    = [aws_security_group.sg_for_alb.id]
    subnets            = [aws_subnet.subnets[0].id, aws_subnet.subnets[1].id]

    depends_on = [
        aws_security_group.sg_for_ecs
    ]
}

resource "aws_lb_target_group" "targetgroupforalb" {
    name     = "Targetgroupforalb"
    protocol = "HTTP"
    port     = 80
    vpc_id   = aws_vpc.myvpc.id 
    target_type = "ip"

    health_check {
        healthy_threshold   = 3
        interval            = 30
        protocol            = "HTTP"
        matcher             = "200"
        timeout             = 3
        path                = "/"
        unhealthy_threshold = 2
    }

    depends_on = [
        aws_lb.lb_for_ecs
    ]
}

resource "aws_lb_listener" "listerforalb" {
    load_balancer_arn = aws_lb.lb_for_ecs.arn
    port = 80
    protocol = "HTTP"
    default_action {
      type = "forward"
      target_group_arn = aws_lb_target_group.targetgroupforalb.arn
    }
    depends_on = [ 
        aws_lb_target_group.targetgroupforalb
     ]
}