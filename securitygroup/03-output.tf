output "scg_id" {
  description = "The ID of ther SecurityGroup"
  value       = { for key, scg in aws_security_group.default : key => scg.id }
}

output "scg_rule" {
  value = { for scg_key, scg in aws_security_group.default : "${scg_key}(${scg.name})" => flatten([
    values({ for scgr_key, scgr in aws_security_group_rule.sgr_cidr_blocks :
      scgr_key => format("Port : %s, Source : %s, Description : %s", split("_", scgr_key)[1], split("_", scgr_key)[2], scgr.description)
      if split("_", scgr_key)[0] == scg_key
    }),
    values({ for scgr_key, scgr in aws_security_group_rule.sgr_source_security_group_id :
      scgr_key => format("Port : %s, Source : %s, Description : %s", split("_", scgr_key)[1], split("_", scgr_key)[2], scgr.description)
      if split("_", scgr_key)[0] == scg_key
    })
    ])
  }
}