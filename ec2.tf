#Create Key Pair
resource "tls_private_key" "prodKey" {
  algorithm = "RSA"
  rsa_bits  = 1024
}

resource "local_file" "private-key" {
  filename        = "${path.root}/${var.private_key}"
  content         = tls_private_key.prodKey.private_key_pem
  file_permission = "600"
}

resource "aws_key_pair" "ec2_key_pair" {
  key_name   = var.public_key_name
  public_key = tls_private_key.prodKey.public_key_openssh
}

resource "aws_security_group" "server_sg" {
  vpc_id = aws_vpc.VPC.id
  name   = var.sg_description
  tags = {
    Name = var.sg_tag
  }
}

resource "aws_vpc_security_group_ingress_rule" "ingress_all_allow" {
  security_group_id = aws_security_group.server_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

resource "aws_vpc_security_group_egress_rule" "egress_all_allow" {
  security_group_id = aws_security_group.server_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # all protocol allow
}
resource "aws_instance" "EC2" {
  ami           = local.selected_ami
  instance_type = var.instance_type
  key_name = aws_key_pair.ec2_key_pair.key_name
  subnet_id = aws_subnet.pub_subnet.id
  vpc_security_group_ids = [aws_security_group.server_sg.id]

  tags = merge(local.common_tags,{
    Name = var.instance_Name
  })
}

resource "aws_eip_association" "allocation_to-ec2" {
  allocation_id = aws_eip.EC2_EIP.id
  instance_id = aws_instance.EC2.id
}