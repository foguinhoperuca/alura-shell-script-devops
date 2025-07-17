resource "aws_security_group" "access-ssh" {
    name = "access-ssh"
    description = "access-ssh"
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = var.cidr_blocks_remote_access
    }
    egress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = var.cidr_blocks_remote_access
    }
    tags = {
        Name = "access"
    }
}

resource "aws_security_group" "access-ssh-us-east-2" {
    provider = aws.us-east-2
    name = "access-ssh-us-east-2"
    description = "access-ssh for regio us-east-2"
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = var.cidr_blocks_remote_access
    }
    egress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = var.cidr_blocks_remote_access
    }
    tags = {
        Name = "access"
    }
}
