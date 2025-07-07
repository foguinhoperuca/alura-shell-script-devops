provider "aws" {
  version = "~> 2.0"
  region = "us-east-1"
}

# TODO generate local ssh key to this project.
resource "aws_instance" "dev" {
  ami = "ami-020cba7c55df1f615"
  instance_type = "t2.micro"
  key_name = "terraform-aws"
}
