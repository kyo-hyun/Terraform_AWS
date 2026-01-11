# nic
resource "aws_network_interface" "testnic" {
  subnet_id         = var.subnet
  private_ips       = [var.private_ip]
  security_groups   = var.sg_id
 
  tags = {
    Name            = "Test_NIC_${var.name}"
  }
}

# ec2
resource "aws_instance" "testec2" {
  ami                     = var.ami
  instance_type           = var.type
  user_data               = var.user_data
  iam_instance_profile    = aws_iam_instance_profile.ec2_profile.name

  network_interface {
    network_interface_id  = aws_network_interface.testnic.id
    device_index          = 0
  }

  root_block_device {
    volume_size           = var.root_ebs.root_ebs_size
    volume_type           = var.root_ebs.root_ebs_type
    tags = {
      Name                = "${var.name}_root_ebs"
    }
  }

  tags = {
    Name                  = var.name
  }
}

# ebs
resource "aws_ebs_volume" "testebs" {
  for_each          = var.add_ebs
  availability_zone = var.availability_zone
  size              = each.value.size
  snapshot_id       = try(each.value.snapshot_id,null)
  tags = {
    Name            = "${var.name}-add_ebs-${each.key}"
  }
}

# ebs attach
resource "aws_volume_attachment" "ebs_att" {
  for_each          = var.add_ebs
  device_name       = each.value.device_name
  volume_id         = aws_ebs_volume.testebs[each.key].id
  instance_id       = aws_instance.testec2.id
}

# eip association
resource "aws_eip_association" "eip_assoc" {
  count             = var.eip_name != null ? 1 : 0
  instance_id       = aws_instance.testec2.id
  allocation_id     = var.eip
}

# ec2 profile
resource "aws_iam_instance_profile" "ec2_profile" {
  name = "${var.name}_profile"
  role = var.role
}