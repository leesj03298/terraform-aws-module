locals {
  middle_name = var.middle_name
}

#### AWS Sagemaker Domain #######################################################################################################
resource "aws_sagemaker_domain" "default" {
  # for_each                = { for domain in var.domain : domain.domain_name => var.domain }
  for_each                = toset([var.domain_name])
  domain_name             = each.key
  auth_mode               = var.auth_mode
  app_network_access_type = var.app_network_access_type
  vpc_id                  = var.vpc_id[var.vpc_identifier]
  subnet_ids              = [for sub_identifier in var.subnet_identifiers : var.sub_id[sub_identifier]]
  # app_security_group_management
  # domain_settings
  # kms_key_id
  # retention_policy
  default_user_settings {
    execution_role = var.execution_role
    # security_groups = 
    sharing_settings {

    }
    jupyter_server_app_settings {

    }
    kernel_gateway_app_settings {

    }
    canvas_app_settings {
      model_register_settings {
        status                                = try(var.canvas_app_settings.model_register_settings.status, null)
        cross_account_model_register_role_arn = try(var.canvas_app_settings.model_register_settings.cross_account_model_register_role_arn, null)
      }
      time_series_forecasting_settings {
        status                   = try(var.canvas_app_settings.time_series_forecasting_settings.status, null)
        amazon_forecast_role_arn = try(var.canvas_app_settings.time_series_forecasting_settings.amazon_forecast_role_arn, null)
      }
      workspace_settings {
        s3_artifact_path = try(var.canvas_app_settings.workspace_settings.s3_artifact_path, null)
        s3_kms_key_id    = try(var.canvas_app_settings.workspace_settings.s3_kms_key_id, null)
      }
      direct_deploy_settings {
        status = try(var.canvas_app_settings.direct_deploy_settings.status, null)
      }
      # identity_provider_oauth_settings {
      #   status           = var.canvas_app_settings.identity_provider_oauth_settings.status
      #   secret_arn       = var.canvas_app_settings.identity_provider_oauth_settings.status == "DISABLED" ? null : var.canvas_app_settings.identity_provider_oauth_settings.secret_arn
      #   data_source_name = var.canvas_app_settings.identity_provider_oauth_settings.status == "DISABLED" ? null : var.canvas_app_settings.identity_provider_oauth_settings.data_source_name
      # }
      kendra_settings {
        status = try(var.canvas_app_settings.kendra_settings.status, null)
      }
    }
    tensor_board_app_settings {

    }
    r_session_app_settings {

    }
    r_studio_server_pro_app_settings {
      user_group    = try(var.r_studio_server_pro_app_settings.user_group, null)
      access_status = try(var.r_studio_server_pro_app_settings.access_status, null)
    }
  }
}