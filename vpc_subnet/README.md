# Terraform AWS Module
- Terraform Repo URL : https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc

## Example Template
```HCL
locals {
  region            = var.region
  project_code      = var.project_code
  environment       = var.environment
  middle_name       = lower(join("-", [local.region, local.project_code, local.environment]))
}

module "vpc_subnet" {
  source            = "../terraform-aws-module/vpc_subnet"

  middle_name = local.middle_name
  vpcs = [
    {
      identifier  = "dmz-01",
      name_prefix = "dmz-01",
      cidr_block  = "10.200.0.0/23"
      igw_enable  = true
    }
  ]
  subnets = [
    {
      vpc_identifier         = "dmz-01",
      identifier             = "dmz-lb-01a",
      name_prefix            = "dmz-lb-01a",
      availability_zone      = "ap-northeast-2a",
      cidr_block             = "10.200.0.0/27",
      route_table_identifier = "dmz-lb"
    },
    {
      vpc_identifier         = "dmz-01",
      identifier             = "dmz-lb-01c",
      name_prefix            = "dmz-lb-01c",
      availability_zone      = "ap-northeast-2c",
      cidr_block             = "10.200.0.32/27",
      route_table_identifier = "dmz-lb"
    },
    {
      vpc_identifier         = "dmz-01",
      identifier             = "dmz-app-01a",
      name_prefix            = "dmz-app-01a",
      availability_zone      = "ap-northeast-2a",
      cidr_block             = "10.200.0.64/27",
      route_table_identifier = "dmz-app"
    },
    {
      vpc_identifier         = "dmz-01",
      identifier             = "dmz-app-01c",
      name_prefix            = "dmz-app-01c",
      availability_zone      = "ap-northeast-2c",
      cidr_block             = "10.200.0.96/27",
      route_table_identifier = "dmz-app"
    },
    {
      vpc_identifier         = "dmz-01",
      identifier             = "dmz-db-01a",
      name_prefix            = "dmz-db-01a",
      availability_zone      = "ap-northeast-2a",
      cidr_block             = "10.200.0.128/27",
      route_table_identifier = "dmz-db"
    },
    {
      vpc_identifier         = "dmz-01",
      identifier             = "dmz-db-01c",
      name_prefix            = "dmz-db-01c",
      availability_zone      = "ap-northeast-2c",
      cidr_block             = "10.200.0.160/27",
      route_table_identifier = "dmz-db"
    },
  ]
  route_tables = [
    {
      vpc_identifier = "dmz-01",
      identifier     = "dmz-lb",
      name_prefix    = "dmz-lb"
    },
    {
      vpc_identifier = "dmz-01",
      identifier     = "dmz-app",
      name_prefix    = "dmz-app"
    },
    {
      vpc_identifier = "dmz-01",
      identifier     = "dmz-db",
      name_prefix    = "dmz-db"
    },
  ]
}
```