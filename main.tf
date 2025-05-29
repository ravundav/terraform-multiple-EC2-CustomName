provider "aws" {
  region = "us-east-1"
access_key = var.aws_access_key
secret_key = var.aws_secret_key

}

variable "aws_access_key" {}
variable "aws_secret_key" {}

resource "aws_instance" "aws-training" {
  count         = 1
  ami           = "ami-084568db4383264d4"
  instance_type = "t2.xlarge"
  key_name      = "Trng-rk"

  tags = {
    #Name = "docker-${count.index + 1}"
    Name = var.instance_names[count.index]
  }

  user_data = <<-EOF
    #!/bin/bash
    sudo apt-get update -y
    sudo curl -fsSL https://get.docker.com -o get-docker.sh
    sudo sh get-docker.sh

    # Terraform
    sudo apt-get update
    sudo apt-get install -y apt-transport-https ca-certificates curl gpg
    sudo mkdir -m 755 -p /etc/apt/keyrings
    curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.33/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
    echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.33/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
    sudo apt-get update
    sudo apt-get install -y kubelet kubeadm kubectl
    sudo apt-mark hold kubelet kubeadm kubectl
  EOF
  root_block_device {
    volume_size = 15
    volume_type = "gp3"
  }
}
