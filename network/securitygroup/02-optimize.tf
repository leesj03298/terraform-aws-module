locals {
  middle_name = var.middle_name
  SecurityGroup_Optimized = flatten([for SecurityGroups in var.securitygroups : [
    for SecurityGroup in SecurityGroups.scgs : {
      vpc_identifier = SecurityGroups.vpc_identifier
      identifier     = SecurityGroup.identifier
      name_prefix    = SecurityGroup.name_prefix
      description    = SecurityGroup.description
      tags           = SecurityGroup.tags
    }
  ]])
}
