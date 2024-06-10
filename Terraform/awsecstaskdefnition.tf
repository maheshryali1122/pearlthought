resource "aws_ecs_task_definition" "taskforecs" {
    family = "nodejstaskdefinition"
    requires_compatibilities = ["FARGATE"]
    network_mode = "awsvpc"
    cpu = "256"
    ram = "512"
    container_definitions = jsonencode([{
        name = "nodejsapplication"
        image = "891376986113.dkr.ecr.us-west-2.amazonaws.com/nodejsrepo:26f7ac5701c738a3e5d54cd274dca122f5f142e9"
        essential = true
        portMappings = [{
            containerPort = 3000
            hostPort = 3000
        }]
    }])
    execution_role_arn = aws_iam_role.taskexecutionroleecs.arn
    task_role_arn = aws_iam_role.taskexecutionroleecs.arn
}