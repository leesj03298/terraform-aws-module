#### Share Variable 
variable "middle_name" {
  description = "Name Tags Middle Name(*Ex : join('-', ['vpc', var.middle_name, each.value.name_prefix]))"
  type        = string
}

variable "vpc_id" {
  description = "The id of the VPC"
  type        = map(string)
}

variable "sub_id" {
  description = "The id of the Subnet"
  type        = map(string)
}

variable "scg_id" {
  description = "The id of the SecurityGroups"
  type        = map(string)
}

variable "sagemaker_domain" {
  type = list(object({
    auth_mode   = optional(string, "IAM")
    domain_name = string
    subnet_ids  = optional(list(string), [])
    vpc_id      = optional(string, null)
    ### app_network_access_type(optional) - Specifies the VPC used for non-EFS traffic. 
    ### The default value is PublicInternetOnly. Valid values are PublicInternetOnly and VpcOnly
    app_network_access_type = optional(string, "PublicInternetOnly")

    ### app_security_group_management(optional) - the entity that creates and manageds the requred security groups for inter-app communication in VPCOnly mode.
    ### Valid values are Service and Customer
    app_security_group_management = optional(string, null)

    ### kms_key_id - (Optional) The AWS KMS customer managed CMK used to encrypt the EFS volume attached to the domain.
    kms_key_id = optional(string, null)

    default_space_setting = optional(object({
      ### execution_role(Required) - The execution role for the space.
      execution_role = optional(string, null)

      ### security_groups(Optional) - The security groups for the Amazon VPC that the space uses for communication.
      security_groups = optional(list(string), [])
      jupyter_server_app_settings = optional(object({

        }),
        {

      })
      kernel_gateway_app_settings = optional(object({

        }),
        {

      })

      }),
      {

    })

    default_user_settings = optional(object({
      canvas_app_settings = optinoal(object({
        model_register_settings = optional(object({
          cross_account_model_register_role_arn = optional(string, null)
          status                                = optional(string, null)
          }),
          {
            cross_account_model_register_role_arn = null,
            status                                = null
        })
        time_series_forecasting_settings = optional(object({
          amazon_forecast_role_arn = optional(string, null)
          status                   = optional(string, null)
          }),
          {
            amazon_forecast_role_arn = null
            status                   = null
        })
        workspace_settings = optional(object({
          s3_artifact_path = optional(string, null)
          s3_kms_key_id    = optional(string, null)
          }),
          {
            s3_artifact_path = null
            s3_kms_key_id    = null
        })
        direct_deploy_settings = optional(object({
          status = optional(string, null)
          }),
          {
            status = null
        })
        identity_provider_oauth_settings = optional(object({
          status           = optional(string, "DISABLED")
          data_source_name = optional(string, null)
          secret_arn       = optional(string, null)
          }),
          {
            status           = "DISABLED"
            data_source_name = null
            secret_arn       = null
        })
        kendra_settings = optional(object({
          status = optional(string, null)
          }),
          {
            status = null
        })
        }),
        {

      })
      code_editor_app_settings = optinoal(object({

        }),
        {

      })
      custom_file_system_config = optinoal(object({
        efs_file_system_config = optional(object({
          file_system_id   = optional(string, null)
          file_system_path = optional(string, null)
        }), null)
        }),
        {

      })
      custom_posix_user_config = optinoal(object({
        uid = optional(string, null)
        gid = optional(string, null)
        }),
        {
          uid = null
          gid = null
      })
      default_landing_uri = optional(stirng, null)
      execution_role      = optional(stirng, null)
      jupyter_server_app_settings = optinoal(object({

        }),
        {

      })
      kernel_gateway_app_settings = optinoal(object({

        }),
        {

      })
      r_sesstion_app_settings = optinoal(object({

        }),
        {

      })
      r_studio_server_pro_app_settings = optinoal(object({
        ###  (Optional) access_status 
        ### Indicates whether the current user has access to the RStudioServerPro app. 
        ### Valid values are ENABLED and DISABLED
        access_status = optional(string, "DISABLED")

        ### user_group - (Optional) The level of permissions that the user has within the RStudioServerPro app. 
        ### This value defaults to R_STUDIO_USER. The R_STUDIO_ADMIN value allows the user access to the RStudio Administrative Dashboard. Valid values are R_STUDIO_USER and R_STUDIO_ADMIN.
        user_group = optional(string, "R_STUDIO_USER")
        }),
        {
          access_status = optional(string, "DISABLED")
          user_group    = optional(string, "R_STUDIO_USER")
        }
      )
      security_groups = optional(list(string), [])
      sharing_settings = optinoal(object({

        }),
        {

      })
      studio_web_portal = optional(string, "DISABLED")
      tensor_board_app_settings = optinoal(object({

        }),
        {

      })
      }),
      {

    })
    domain_settings = optional(object({

      }),
      {

    })
    retention_policy = optional(object({

      }), {

    })
    tags = ooptional(map(string), {})
  }))

  validation {
    condition     = alltrue([for object in var.sagemaker_domain : object.default_space_setting.execution_role != null])
    error_message = "Required : default_space_setting.execution_role"
  }
}