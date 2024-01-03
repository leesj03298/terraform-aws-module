locals {
  Share_Middle_Name = var.Share_Middle_Name
  SecurityGroup_Optimize = flatten([for SecurityGroups in var.security_groups : [
    for SecurityGroup in SecurityGroups.securitygroups : {
      vpc_identifier = SecurityGroups.vpc_identifier
      identifier     = SecurityGroup.identifier
      name_prefix    = SecurityGroup.name_prefix
      description    = SecurityGroup.description
      tags           = SecurityGroup.tags
    }
    ]
    ]
  )
}
