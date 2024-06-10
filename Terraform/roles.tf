resource "aws_iam_role" "taskexecutionroleecs" {
    name = "taskexecutionroleecs"
    assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [{
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
            Service = "ecs-tasks.amazonaws.com"
        }
        }]
    })
    managed_policy_arns = [
        "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy" #This policy has permissions with ecr cloudwatch etc
    ]
  
}