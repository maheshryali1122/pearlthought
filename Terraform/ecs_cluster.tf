resource "aws_ecs_cluster" "ecs_nodejs" {
    name = "Ecsnodejs"
    tags = {
        Name = "Ecsnodejs"
    }

    depends_on = [
        aws_iam_role.taskexecutionroleecs
    ]
}
