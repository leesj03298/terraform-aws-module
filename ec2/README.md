# Terraform AWS Module - LEE SEUNG JOON : EC2


## Version
- terraform : >=1.3.0
- plugin : "5.20.0" 

## Create Resource List
- `aws_instance`
- `aws_ebs_volume`
- `aws_volume_attachment`
- `aws_eip`
- `aws_network_interface`
  
## Varaible
|No.|Attribute|Required|Type|Default Value|Description|
|---|---|:---:|:---:|:---:|---|
|1  |identifier               |Y    |string         |null       |
|2  |name_prefix              |Y    |string         |null       |
|3  |ami                      |Y    |string         |null       |
|4  |instance_type            |N    |string         |`t3.micro` |
|5  |sub_identifier           |Y    |string         |null       |
|6  |scg_identifier           |Y    |list(string)   |null       |
|7  |iam_instance_profile     |N    |string         |null       | 
|8  |user_data                |N    |string         |null       |
|9  |key_name                 |N    |string         |null       |
|10 |public_ip                |N    |bool           |false      | 
|11 |privaete_ip              |N    |string         |null       | 
|12 |root_block_device        |Y    |lsit(any)      |           | 
|13 |ebs_block_device         |N    |list(object)   |null       | 
|14 |tags                     |N    |map(string)    |null       |

## Example Code

