provider "aws" {
  region = "eu-west-1"
}

resource "aws_instance" "ec2_instances" {
  count         = 3
  ami           = "ami-0905a3c97561e0b69"  # Use your actual AMI ID
  instance_type = "t2.micro"               # Choose instance type

  tags = {
    Name = "instance-${count.index + 1}"
  }
}

resource "aws_elb" "load_balancer" {
  availability_zones = aws_instance.ec2_instances[*].availability_zone
  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  instances = aws_instance.ec2_instances[*].id

  tags = {
    Name = "my-tf-lb"
  }
}