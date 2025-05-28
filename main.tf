provider "aws" {
  region = "us-east-1"
access_key = var.aws_access_key
secret_key = var.aws_secret_key

}

variable "aws_access_key" {}
variable "aws_secret_key" {}

resource "aws_instance" "aws-training" {
  count         = 28
  ami           = "ami-084568db4383264d4"
  instance_type = "t2.medium"
  key_name      = "Trng-rk"

  tags = {
    #Name = "docker-${count.index + 1}"
    Name = var.instance_names[count.index]
  }
  user_data = <<-EOF
    #!/bin/bash
    sudo apt-get update -y
    sudo curl -fsSL https://get.docker.com -o get-docker.sh
    sudo sudo sh get-docker.sh
  EOF
}
