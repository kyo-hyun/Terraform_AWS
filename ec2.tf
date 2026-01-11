locals {
  ec2_list = {
    "ec2-1" = {
      ami               = "ami-0eb302fcc77c2f8bd"
      type              = "t2.micro"
      vpc               = "test-vpc"
      availability_zone = "ap-northeast-2a"
      subnet            = "test-snet-a"
      private_ip        = "10.0.0.5"
      eip               = "eip_test2"
      security_group    = ["ec2-1-sg"]

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

    # "ec2-2" = {
    #   ami               = "ami-0eb302fcc77c2f8bd"
    #   type              = "t2.micro"
    #   vpc               = "test-vpc"
    #   availability_zone = "ap-northeast-2c"
    #   subnet            = "test-snet-c"
    #   private_ip        = "10.0.1.5"
    #   eip               = "eip_test3"
    #   security_group    = ["ec2-2-sg"]

    #   user_data         = <<-EOF
    #                       #!/bin/bash
    #                       echo "QWERasdf123!!" | passwd ec2-user --stdin
    #                       sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
    #                       systemctl restart sshd
    #                       yum install -y httpd
    #                       systemctl restart httpd
    #                       echo "ap-northeast-2c" >> /var/www/html/index.html
    #                       EOF

    #   root_ebs = {
    #     root_ebs_type = "gp3"
    #     root_ebs_size = 30
    #   }

    #   add_ebs = {

    #   }
    # }

    # "ec2-nitron-c5large" = {
    #   ami               = "ami-0cf1ead55e8259a57"
    #   type              = "c5.large"
    #   vpc               = "Hub-vpc"
    #   availability_zone = "ap-northeast-2a"
    #   subnet            = "hub-mgmt-snet-a"
    #   private_ip        = "10.0.3.8"
    #   eip               = "eip_test4"
    #   security_group    = ["hub-vpc-sg"]

    #   user_data         = <<-EOF
    #                       #!/bin/bash
    #                       echo "QWERasdf123!!" | passwd ec2-user --stdin
    #                       sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
    #                       systemctl restart sshd
    #                       yum install -y httpd
    #                       systemctl restart httpd
    #                       echo "Hello Terraform" >> /var/www/html/index.html
    #                       EOF

    #   root_ebs = {
    #     root_ebs_type = "gp3"
    #     root_ebs_size = 30
    #   }

    #   add_ebs = {

    #   }
    # }

    # "spoke1-ec2" = {
    #   ami               = "ami-0eb302fcc77c2f8bd"
    #   type              = "t2.micro"
    #   vpc               = "spoke2-vpc"
    #   availability_zone = "ap-northeast-2a"
    #   subnet            = "private-ec2-snet"
    #   private_ip        = "11.0.0.5"
    #   #eip               = "eip_test2"
    #   security_group    = ["spoke1-vpc-sg"]

    #   user_data         = <<-EOF
    #                       #!/bin/bash
    #                       echo "QWERasdf123!!" | passwd ec2-user --stdin
    #                       sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
    #                       systemctl restart sshd
    #                       yum install -y httpd
    #                       systemctl restart httpd
    #                       echo "Hello Terraform" >> /var/www/html/index.html
    #                       EOF
    #   root_ebs = {
    #     root_ebs_type = "gp3"
    #     root_ebs_size = 30
    #   }

    #   add_ebs = {

    #   }
  }
}

module "ec2" {
  source   = "./module/EC2"
  for_each = local.ec2_list

  name              = each.key
  sg_id             = [for sg in each.value.security_group : module.sg[sg].get_sg_id]
  # az는 ebs 생성시 필요
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