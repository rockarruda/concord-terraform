resource "aws_instance" "main" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  vpc_security_group_ids      = [aws_security_group.main.id]
  key_name                    = var.keypair
  associate_public_ip_address = var.instance_public
  # TODO: This needs to be made conditional based on the presence of a user_data variable
  user_data                   = filebase64(var.ec2_user_data)
  tags                        = merge({ Name = var.instance_name }, var.tags)
}

resource "aws_security_group" "main" {
  name = var.instance_name
  vpc_id = data.aws_vpc.selected.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = var.ssh_port
    to_port   = var.ssh_port
    protocol  = "tcp"

    # To keep this example simple, we allow incoming SSH requests from any IP. In real-world usage, you should only
    # allow SSH requests from trusted servers, such as a bastion host or VPN server.
    cidr_blocks = ["0.0.0.0/0"]
  }
}
