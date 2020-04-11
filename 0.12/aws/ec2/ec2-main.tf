resource "aws_instance" "main" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.ec2_instance_type
  vpc_security_group_ids      = [aws_security_group.main.id]
  key_name                    = var.ec2_keypair
  associate_public_ip_address = var.ec2_instance_public
  user_data                   = fileexists(var.ec2_user_data) ? filebase64(var.ec2_user_data) : ""
  tags                        = merge({ Name = var.ec2_instance_name }, var.tags)

  root_block_device {
    volume_type = var.ec2_root_block_device_type
    volume_size = var.ec2_root_block_device_size
    delete_on_termination = var.ec2_root_block_device_delete_on_termination
  }
}

resource "aws_security_group" "main" {
  name = var.ec2_instance_name
  vpc_id = data.aws_vpc.selected.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = var.ec2_ssh_port
    to_port   = var.ec2_ssh_port
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
