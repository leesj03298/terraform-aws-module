
#### EC2 ########################################################################################################################
resource "aws_instance" "default" {
  for_each               = { for ec2 in var.ec2 : ec2.identifier => ec2 }
  ami                    = each.value.ami
  instance_type          = each.value.instance_type
  subnet_id              = var.sub_id[each.value.sub_identifier]
  availability_zone      = var.sub_az[each.value.sub_identifier]
  vpc_security_group_ids = [for scg_identifier in each.value.scg_identifier : var.scg_id[scg_identifier]]
  private_ip             = each.value.private_ip
  iam_instance_profile   = each.value.iam_instance_profile
  user_data              = each.value.user_data
  key_name               = each.value.key_name
  dynamic "root_block_device" {
    for_each = each.value.root_block_device
    content {
      volume_type           = root_block_device.value.ebs_block[0]
      volume_size           = root_block_device.value.ebs_block[1]
      iops                  = try(root_block_device.value.ebs_block[2], null)
      throughput            = try(root_block_device.value.ebs_block[3], null)
      delete_on_termination = try(root_block_device.value.delete_on_termination, null)
      encrypted             = try(root_block_device.value.ebs_device_encrypted.encrypted, null)
      kms_key_id            = try(root_block_device.value.ebs_device_encrypted.kms_key_id, null)
      tags = {
        "Name" = join("-", ["ebs", var.middle_name, each.value.name_prefix])
      }
    }
  }
  tags = merge(each.value.tags, { "Name" = join("-", ["ec2", var.middle_name, each.value.name_prefix]) })
}

#### EBS ########################################################################################################################
resource "aws_ebs_volume" "default" {
  for_each          = { for EBS_BLOCK_LIST in local.EBS_BLOCK_LIST : "${EBS_BLOCK_LIST.EC2_instance_identifier}_${EBS_BLOCK_LIST.ebs_block[0]}" => EBS_BLOCK_LIST }
  availability_zone = each.value.availability_zone
  type              = each.value.ebs_block[1]
  size              = each.value.ebs_block[2]
  iops              = try(each.value.ebs_block[3], null)
  throughput        = try(each.value.ebs_block[4], null)
  encrypted         = each.value.ebs_device_encrypted.encrypted
  kms_key_id        = each.value.ebs_device_encrypted.kms_key_id
}

resource "aws_volume_attachment" "default" {
  for_each    = { for EBS_BLOCK_LIST in local.EBS_BLOCK_LIST : "${EBS_BLOCK_LIST.EC2_instance_identifier}_${EBS_BLOCK_LIST.ebs_block[0]}" => EBS_BLOCK_LIST }
  device_name = each.value.ebs_block[0]
  volume_id   = aws_ebs_volume.default["${each.key}"].id
  instance_id = aws_instance.default["${each.value.EC2_instance_identifier}"].id
}

#### EIP ########################################################################################################################
resource "aws_eip" "default" {
  for_each                  = { for eip in var.ec2 : eip.identifier => eip if eip.public_ip == true && length(aws_instance.default) != 0 }
  instance                  = aws_instance.default[each.key].id
  associate_with_private_ip = aws_instance.default[each.key].private_ip
  tags                      = merge(each.value.tags, { "Name" = join("-", ["eip", var.middle_name, each.value.name_prefix]) })
}


#### ENI ########################################################################################################################
resource "aws_network_interface" "default" {
  for_each = { for eni in var.enis : "${eni.instance_identifier}-${eni.device_index}" => eni
  if eni.instance_identifier != null }
  subnet_id       = each.value.subnet_id
  private_ips     = each.value.private_ips
  security_groups = each.value.security_groups
  attachment {
    instance     = aws_instance.default["${each.value.instance_identifier}"].id
    device_index = each.value.device_index
  }
}


