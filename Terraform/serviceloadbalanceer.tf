resource "aws_security_group" "sg_for_alb" {
    name = "Sgforalb"
    vpc_id = aws_vpc.myvpc.id
    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags = {
        Name = "Sgforalb"
    }
}
resource "aws_security_group" "sg_for_ecs" {
    name = "sgforecs"
    vpc_id = aws_vpc.myvpc.id
    ingress {
        from_port = 3000
        to_port = 3000
        protocol = "tcp"
        security_groups = ["aws_security_group.sg_for_alb.id"]
    }  
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}
resource "aws_lb" "lb_for_ecs" {
    name = "lbforecs"
    internal = false
    load_balancer_type = "application"
    security_groups = ["aws_security_group.sg_for_alb.id"]
    subnets = [aws_subnet.subnets[0].id, aws_subnet.subnets[1].id]
}
resource "aws_lb_target_group" "targetgroupforalb" {
    name = "Targetgroupforalb"
    protocol = "HTTP"
    port = 80
    vpc_id = aws_vpc.myvpc.id 
}
resource "aws_lb_listener" "listerforalb" {
    load_balancer_arn = aws_lb.lb_for_ecs.arn
    port = 80
    protocol = "HTTP"
    default_action {
      type = "forward"
      target_group_arn = aws_lb_target_group.targetgroupforalb.arn
    }
}