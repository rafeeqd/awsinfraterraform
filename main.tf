# Terraform HCL

provider "aws" {
  region                  = "us-east-1"
  shared_credentials_file = "~/.aws/credentials"
  profile                 = "default"
}

resource "aws_instance" "ubuntu" {
  ami                         = var.amiid[0]
  count                       = 3
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.subnet1.id
  associate_public_ip_address = true
  key_name                    = "ansibleserverskey"
  vpc_security_group_ids      = [aws_security_group.web.id]
  #disable_api_termination = false

  tags = {
    Name = "AnsibleServer${count.index}"

  }

}
resource "null_resource" "makedir" {
  count =3
  provisioner "remote-exec" {
    inline = ["mkdir rafeeq"]
    connection {
      host = aws_instance.ubuntu[count.index].public_dns
      #host="10.0.0.133"
      type = "ssh"
      user = "ec2-user"
      #private_key    = "newkey"
      #private_key ="privatekey_key.ppk"
      private_key = file("ansibleserverskey.pem")


      timeout = "1m"
    }

  }
}


resource "aws_security_group" "web" {

  name        = "web-sec-group"
  description = " Allows SSH"
  vpc_id      = aws_vpc.prodvpcterraform.id
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}



resource "aws_vpc" "prodvpcterraform" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {

    Name = "VPC for Ansible"
  }
}
resource "aws_subnet" "subnet1" {
  vpc_id     = aws_vpc.prodvpcterraform.id
  cidr_block = "10.0.0.0/24"
  tags = {

    Name = "Subnet for Ansible"
  }

}


output "dnsoutput" {
 
  value = aws_instance.ubuntu
}

