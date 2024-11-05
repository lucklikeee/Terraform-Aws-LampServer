# Creating key-pair on AWS using SSH-public key
resource "aws_key_pair" "deployer" {
  key_name   = var.key-name
  public_key = file("${path.module}/tftest.pub")
}

# Creating a security group to restrict/allow inbound connectivity
resource "aws_security_group" "network-security-group" {
  name        = var.network-security-group-name
  description = "Allow TLS inbound traffic"

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] 
    }
  
  ingress {
    description = "WHM"
    from_port   = 2087
    to_port     = 2087
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] 
    }
  
  egress {
    description = "All trafic"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
    }
  
tags = {
    Name = "tftest"
  }
}


# Creating EC2 instance
resource "aws_instance" "vm-instance" {
  ami             = var.almalinux-ami
  instance_type   = var.instance-type
  key_name        = aws_key_pair.deployer.key_name
  vpc_security_group_ids = [aws_security_group.network-security-group.id]
  #associate_public_ip_address = true
  #user_data                   = file("install.sh")
  provisioner "file" {
     source="/root/tftest/cpanel-dnsonly/install.sh"
     destination="/tmp/install.sh"
	}
  provisioner "file" {
     source="/root/tftest/cpanel-dnsonly/dnsonly-install.tgz"
     destination="/tmp/dnsonly-install.tgz"
        }
  provisioner "remote-exec" {
  inline=[
  "sudo sh /tmp/install.sh"
  ]
	}
  
  connection {
      type        = "ssh"
      host        = self.public_ip
      user        = "ec2-user"
      private_key = file("/root/tftest/cpanel-dnsonly/tftest")
      timeout     = "4m"
   }

   tags = {
    Name = "cPanel-DNSOnly-TESTE"
  }
}
