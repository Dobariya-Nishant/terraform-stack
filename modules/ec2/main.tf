resource "aws_instance" "this" {
  ami                         = data.aws_ami.this.id
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  key_name                    = aws_key_pair.this.key_name
  security_groups             = var.security_groups
  associate_public_ip_address = true

  ebs_block_device {
    device_name           = "/dev/xvda"
    volume_size           = var.ebs_size
    volume_type           = var.ebs_type
    delete_on_termination = true
    encrypted             = true
  }

  user_data = <<-EOF
    #!/bin/bash
    yum update -y
  EOF

  tags = {
    Name = "${var.name}-ec2-${var.environment}"
  }
}


# ========
# Key Pair
# ========
resource "tls_private_key" "this" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "this" {
  key_name   = "${var.name}-ec2-key-${var.environment}"
  public_key = tls_private_key.this.public_key_openssh
}

resource "local_file" "this" {
  filename        = "${path.root}/keys/${aws_key_pair.this.key_name}.pem"
  content         = tls_private_key.this.private_key_openssh
  file_permission = "0600"
}

data "aws_ami" "this" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }
}

# ===========================================================
# 🔍 Fetch public IP of current machine (used for SSH access)
# ===========================================================
data "http" "my_ip" {
  url = "https://api.ipify.org"
}