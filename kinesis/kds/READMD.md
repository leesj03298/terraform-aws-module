

## Resource
- aws_kinesis_stream

## Ref
 - aws_kinesis_stream : https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kinesis_stream



## Resource : aws_kinesis_stream
### Argument Reference

This resource supports the following arguments:

- name(Required) : A name to identify the stream. This is unique to the AWS account and region the Stream is created in.
- shard_count(Optional) : The number of shards that the stream will use. If the stream_mode is PROVISIONED, this field is required. Amazon has guidelines for specifying the Stream size that should be referenced when creating a Kinesis stream. See Amazon Kinesis Streams for more.
- retention_period(Optional) : Length of time data records are accessible after they are added to the stream. The maximum value of a stream's retention period is 8760 hours. Minimum value is 24. Default is 24.
- shard_level_metrics(Optional) : A list of shard-level CloudWatch metrics which can be enabled for the stream. See Monitoring with CloudWatch for more. Note that the value ALL should not be used; instead you should provide an explicit list of metrics you wish to enable.
- enforce_consumer_deletion(Optional) : A boolean that indicates all registered consumers should be deregistered from the stream so that the stream can be destroyed without error. The default value is false.
- encryption_type(Optional) : The encryption type to use. The only acceptable values are NONE or KMS. The default value is NONE.
- kms_key_id(Optional) : The GUID for the customer-managed KMS key to use for encryption. You can also use a Kinesis-owned master key by specifying the alias alias/aws/kinesis.
- stream_mode_details(Optional) : Indicates the capacity mode of the data stream. Detailed below.
- tags(Optional) : A map of tags to assign to the resource. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level.
  
### stream_mode_details Configuration Block
- stream_mode(Required) : Specifies the capacity mode of the stream. Must be either PROVISIONED or ON_DEMAND.