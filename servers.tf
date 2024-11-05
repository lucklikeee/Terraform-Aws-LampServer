#data "aws_ami" "ubuntu" {
#  most_recent = true
#}


#resource "aws_instance" "test-ec2-instance" {
#  ami = data.aws_ami.ubuntu.id 
#  count = 1
#  instance_type = "t2.micro"
#  key_name = "global" # ssh key
#  subnet_id = var.tcb_blog_subnet_public_id
#  vpc_security_group_ids = [aws_security_group.permitir_ssh_http.id]
#  associate_public_ip_address = true

# tags = {
#    Name = "TFTest"
#  }
#}
