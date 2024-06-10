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
        "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy",
        "arn:aws:iam::aws:policy/CloudFrontFullAccess", 
        "arn:aws:iam::aws:policy/AmazonS3FullAccess", 
        "arn:aws:iam::aws:policy/AmazonElasticContainerRegistryPublicFullAccess", 
        "arn:aws:iam::aws:policy/CloudWatchFullAccess", 
        "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
        
    ]
    depends_on = [ 
        aws_route_table_association.association
     ]
  
}