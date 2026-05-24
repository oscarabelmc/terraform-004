output "instance_id" {
  description = "EC2 instance ID"
  value       = aws_instance.app_core.id
}

output "volume_id" {
  description = "EBS volume ID"
  value       = aws_ebs_volume.data_pr0d_east.id
}

output "attachment_info" {
  description = "Volume attachment details"
  value = {
    device     = aws_volume_attachment.attach_data.device_name
    instance   = aws_volume_attachment.attach_data.instance_id
    volume     = aws_volume_attachment.attach_data.volume_id
  }
}
