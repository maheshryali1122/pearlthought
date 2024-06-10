resource "aws_vpc" "myvpc" {
    cidr_block = var.vpccidr
    tags = {
        Name = "Ecsvpc"
    }
}
resource "aws_subnet" "subnets" {
    count = 2
    availability_zone = var.availabilityzone[count.index]
    cidr_block = cidrsubnet(var.vpccidr, 8, count.index)
    vpc_id = aws_vpc.myvpc.id
    tags = {
        Name = var.subnettagnames[count.index]
    }
}
resource "aws_internet_gateway" "ecsigw" {
    vpc_id = aws_vpc.myvpc.id
    tags = {
        Name = "Ecsigw"
    }
}
resource "aws_route_table" "routetables" {
    vpc_id = aws_vpc.myvpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.ecsigw.id
    }
    tags = {
        Name = "public_route_table"
    }
}
resource "aws_route_table_association" "association" {
    count = 2
    subnet_id = aws_subnet.subnets[count.index].id
    route_table_id = aws_route_table.routetables.id
}