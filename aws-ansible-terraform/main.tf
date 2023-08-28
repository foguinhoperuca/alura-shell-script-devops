terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }

  required_version = ">= 0.14.9"
}

provider "aws" {
  profile = "default"
  region  = "us-west-2"
}

resource "aws_instance" "app_server" {
  ami           = "ami-"
  instance_type = "t2.micro"
  key_name      = "iac-alura"
  user_data     = <<-EOF
                 #!/bin/bash
                 cd /home/ubuntu
                 echo "<h1>Done with Terraform and no Love...</h1>"
                 nohup busybox httpd -f -p 8080 &
                 EOF

  tags = {
    Name = "Alura AWS test"
  }
}
