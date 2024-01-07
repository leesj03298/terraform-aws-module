locals {
  middle_name = var.middle_name
}

#### AWS Sagemaker Domain #######################################################################################################
resource "aws_sagemaker_domain" "example" {
  for_each                = { for domain in tolist(var.domain) : domain.domain_name => domain }
  domain_name             = each.key
  auth_mode               = each.value.auth_mode
  app_network_access_type = each.value.app_network_access_type
  vpc_id                  = each.value.app_network_access_type == "VpcOnly" ? var.vpc_id[each.value.vpc_identifier] : null
  subnet_ids              = each.value.app_network_access_type == "VpcOnly" ? [for sub_identifier in each.value.subnet_identifier : var.sub_id[sub_identifier]] : null
  # app_security_group_management
  # domain_settings
  # kms_key_id
  # retention_policy
  default_user_settings {
    execution_role = each.value.execution_role
    # security_groups = 
    sharing_settings {

    }
    jupyter_server_app_settings {

    }
    kernel_gateway_app_settings {

    }
    canvas_app_settings {
      model_register_settings {
        # cross_account_model_register_role_arn = 
        # status      = 
      }
      time_series_forecasting_settings {
        #   amazon_forecast_role_arn = 
        #   status = 
      }
      workspace_settings {
        #   s3_artifact_path = 
        #   s3_kms_key_id = 
      }
    }
    tensor_board_app_settings {

    }
    r_session_app_settings {

    }
    r_studio_server_pro_app_settings {
      # model_register_settings
      # time_series_forecasting_settings
      # workspace_settings
    }
  }
}