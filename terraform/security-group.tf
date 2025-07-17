resource "aws_security_group" "access-ssh" {
    name = "access-ssh"
    description = "access-ssh"
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        # cidr_blocks = ["170.247.10.21/32"] # PMS 2025-07-14
        cidr_blocks = ["0.0.0.0/0"] # to correct work - I don't have a fixed ip
    }
    egress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        # cidr_blocks = ["170.247.10.21/32"] # PMS 2025-07-14
        cidr_blocks = ["0.0.0.0/0"] # to correct work - I don't have a fixed ip
    }
    tags = {
        Name = "access"
    }
}

resource "aws_security_group" "access-ssh-us-east-2" {
    provider = "aws.us-east-2"
    name = "access-ssh-us-east-2"
    description = "access-ssh for regio us-east-2"
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        # cidr_blocks = ["170.247.10.21/32"] # PMS 2025-07-14
        cidr_blocks = ["0.0.0.0/0"] # to correct work - I don't have a fixed ip
    }
    egress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        # cidr_blocks = ["170.247.10.21/32"] # PMS 2025-07-14
        cidr_blocks = ["0.0.0.0/0"] # to correct work - I don't have a fixed ip
    }
    tags = {
        Name = "access"
    }
}
