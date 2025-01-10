provider "aws" {
  region = "us-east-1"
}

resource "aws_security_group" "allow_ssh" {
  name_prefix = "allow_ssh"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] 
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "test-vm" {
  ami           = "ami-005fc0f236362e99f"  # ubuntu AMI
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]
  key_name = ""

  provisioner "local-exec" {
    command = "sleep 30 && ansible-playbook -u ubuntu -i ${self.public_ip}, --private-key common.pem ansible/ec2.yaml"
  }
}

output "instance_public_ip" {
  value = aws_instance.test-vm.public_ip
}