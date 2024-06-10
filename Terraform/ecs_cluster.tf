resource "aws_ecs_cluster" "ecs_nodejs" {
    name = "Ecsnodejs"
    tags = {
        Name = "Ecsnodejs"
    }
}