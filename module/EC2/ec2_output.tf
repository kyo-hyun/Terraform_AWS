output "get_ec2_id" {
    value = aws_instance.testec2.id
}

output "get_root_ebs_id" {
    value = aws_instance.testec2.root_block_device[0].volume_id
}

output "get_root_ebs_device_name" {
    value = aws_instance.testec2.root_block_device[0].device_name
}

output "get_data_ebs_key" {
    value = {for k,v in var.add_ebs : k => v.size}
}

output "get_data_ebs_ids" {
    value = {for k,v in resource.aws_ebs_volume.testebs : k => v.id}
}