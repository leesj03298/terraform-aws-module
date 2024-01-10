



```HCL
module "redshiftcluster" {
  source      = "${path.module}/../redshift/redshiftcluster"
  scg_id      = local.scg_id
  middle_name = local.middle_name

  name_prefix                  = "test-01"
  database_name                = "dev"
  master_username              = "awsuser"
  cluster_subnet_group_name    = "subgrp-an2-sha-dev-test-01"
  cluster_parameter_group_name = "pargrp-an2-sha-dev-test-01"
}
```