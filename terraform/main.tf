provider "aws" {
  # version = "~> 2.0" # version constraint inside of the provider is deprecated
  region = "us-east-1"
}

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

resource "aws_instance" "dev" {
  count = 3
  # ami - image from ubuntu 24.04
  ami = "ami-020cba7c55df1f615"
  instance_type = "t2.micro"
  key_name = "Openshift-Key used everywhere"
  tags = {
      Name = "dev_${count.index}"
  }
  vpc_security_group_ids = ["${aws_security_group.access-ssh.id}"] # aws-default: sg-0df47e9be592e7453; ${aws_security_group.access-ssh.id} will be convert into: sg-0777fb748b6b6bcf5
}

resource "aws_instance" "dev4" {
  ami = "ami-020cba7c55df1f615"
  instance_type = "t2.micro"
  key_name = "Openshift-Key used everywhere"
  tags = {
      Name = "dev_4"
  }
  vpc_security_group_ids = ["${aws_security_group.access-ssh.id}"] # aws-default: sg-0df47e9be592e7453; ${aws_security_group.access-ssh.id} will be convert into: sg-0777fb748b6b6bcf5
  depends_on = [aws_s3_bucket.bkt01]
}

resource "aws_instance" "dev5" {
  ami = "ami-020cba7c55df1f615"
  instance_type = "t2.micro"
  key_name = "Openshift-Key used everywhere"
  tags = {
      Name = "dev_5"
  }
  vpc_security_group_ids = ["${aws_security_group.access-ssh.id}"] # aws-default: sg-0df47e9be592e7453; ${aws_security_group.access-ssh.id} will be convert into: sg-0777fb748b6b6bcf5
}

resource "aws_s3_bucket" "bkt01" {
    bucket = "jecampos-bkt01"
    acl = "private"
    tags = {
        Name = "jecampos-bkt01"
    }
}
