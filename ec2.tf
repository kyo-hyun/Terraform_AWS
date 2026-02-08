locals {
  ec2_list = {
    "demo-mgmt-ec2" = {
      ami               = "ami-0eb302fcc77c2f8bd"
      type              = "t2.micro"
      vpc               = "demo-vpc"
      availability_zone = "ap-northeast-2a"
      subnet            = "demo-a-ec2-public-snet"
      private_ip        = "10.0.0.5"
      eip               = "eip_ec2_mgmt"
      security_group    = ["demo-sg"]

      user_data         = <<-EOF
                          #!/bin/bash
                          echo "QWERasdf123!!" | passwd ec2-user --stdin
                          sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
                          systemctl restart sshd
                          yum install -y httpd
                          systemctl restart httpd
                          echo "ap-northeast-2a" >> /var/www/html/index.html
                          EOF

      root_ebs = {
        root_ebs_type = "gp3"
        root_ebs_size = 30
      }

      add_ebs = {

      }
    }
}
}

module "ec2" {
  source   = "./module/EC2"
  for_each = local.ec2_list

  name              = each.key
  sg_id             = [for sg in each.value.security_group : module.sg[sg].get_sg_id]
  availability_zone = each.value.availability_zone
  ami               = each.value.ami
  type              = each.value.type
  subnet            = module.vpc[each.value.vpc].get_subnet_id[each.value.subnet]
  private_ip        = each.value.private_ip
  role              = try(each.value.role,null)
  root_ebs          = each.value.root_ebs
  add_ebs           = each.value.add_ebs
  eip               = try(module.eip[each.value.eip].get_eip_id, null)
  eip_name          = try(each.value.eip,null)
  user_data         = each.value.user_data
}