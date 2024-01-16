locals {
  #### TARGET_GROUP_ATTACHMENT_LIST : aws_lb_target_group_attachment List
  EBS_BLOCK_LIST = flatten([for ec2_instance in var.ec2 : [
    for ebs_block in ec2_instance.ebs_block_device : merge(ebs_block, {
      "EC2_instance_identifier" = ec2_instance.identifier
      "availability_zone"       = var.sub_az["${ec2_instance.sub_identifier}"]
    })
  ] if ec2_instance.ebs_block_device != null])
}