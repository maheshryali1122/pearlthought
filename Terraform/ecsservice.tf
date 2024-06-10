resource "aws_ecs_service" "ecsservice" {
    name            = "ecsservicenodejs"
    cluster         = aws_ecs_cluster.ecs_nodejs.id
    task_definition = aws_ecs_task_definition.taskforecs.arn
    desired_count   = 2  
    launch_type     = "FARGATE"

    network_configuration {
        subnets         = [aws_subnet.subnets[0].id, aws_subnet.subnets[1].id]
        security_groups = [aws_security_group.sg_for_ecs.id]
        assign_public_ip = true 
    }

    load_balancer {
        target_group_arn = aws_lb_target_group.targetgroupforalb.arn
        container_name   = "nodejsapplication"
        container_port   = 3000
    }

    depends_on = [
        aws_lb_listener.listerforalb
    ]
}
