resource "aws_eip" "EC2_EIP" {
  tags = {
    Name = var.eip_name
  }
}

