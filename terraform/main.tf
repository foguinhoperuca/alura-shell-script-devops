provider "aws" {
  version = "~> 2.0"
  region = "us-east-1"
}

resource "aws_instance" "dev" {
  count = 3
  # ami - image from ubuntu 24.04
  ami = "ami-020cba7c55df1f615"
  instance_type = "t2.micro"
  key_name = "Openshift-Key used everywhere"
  tags = {
      Name = "dev_${count.index}"
  }
  # vpc_security_group_ids = ["sg-0777fb748b6b6bcf5"]
  vpc_security_group_ids = ["sg-0df47e9be592e7453"]
}

resource "aws_security_group" "access-ssh" {
    name = "access-ssh"
    description = "access-ssh"
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["170.247.10.21/32"] # PMS 2025-07-14
    }
    egress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["170.247.10.21/32"] # PMS 2025-07-14
    }
    tags = {
        Name = "access"
    }
}
