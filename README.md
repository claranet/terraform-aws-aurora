# tf-aws-aurora

AWS Aurora DB Cluster & Instance(s) Terraform Module.

Gives you:

 - A DB subnet group
 - An Aurora DB cluster
 - An Aurora DB instance + 'n' number of additional instances
 - Optionally RDS 'Enhanced Monitoring' + associated required IAM role/policy (by simply setting the `monitoring_interval` param to > `0`
 - Optionally sensible alarms to SNS (high CPU, high connections, slow replication)


## Contributing

Ensure any variables you add have a type and a description.
This README is generated with [terraform-docs](https://github.com/segmentio/terraform-docs):

`terraform-docs md . > README.md`

## Usage example

```
resource "aws_sns_topic" "db_alarms" {
  name = "aurora-db-alarms"
}

module "aurora_db" {
  source                    = "../.."
  name                      = "test-aurora-db"
  envname                   = "test"
  envtype                   = "test"
  subnets                   = ["${module.vpc.private_subnets}"]
  azs                       = ["${module.vpc.availability_zones}"]
  replica_count             = "1"
  security_groups           = ["${aws_security_group.allow_all.id}"]
  instance_type             = "db.t2.medium"
  username                  = "root"
  password                  = "changeme"
  backup_retention_period   = "5"
  final_snapshot_identifier = "final-db-snapshot-prod"
  storage_encrypted         = "true"
  apply_immediately         = "true"
  monitoring_interval       = "10"
  cw_alarms                 = true
  cw_sns_topic              = "${aws_sns_topic.db_alarms.id}"
}
```


## Inputs

| Name | Description | Default | Required |
|------|-------------|:-----:|:-----:|
| apply_immediately | Determines whether or not any DB modifications are applied immediately, or during the maintenance window | `false` | no |
| auto_minor_version_upgrade | Determines whether minor engine upgrades will be performed automatically in the maintenance window | `false` | no |
| azs | List of AZs to use | - | yes |
| backup_retention_period | How long to keep backups for (in days) | `0` | no |
| cw_alarms | Whether to enable CloudWatch alarms - requires `cw_sns_topic` is specified | `false` | no |
| cw_max_conns | Connection count beyond which to trigger a CloudWatch alarm | `500` | no |
| cw_max_cpu | CPU threshold above which to alarm | `85` | no |
| cw_max_replica_lag | Maximum Aurora replica lag in milliseconds above which to alarm | `2000` | no |
| cw_sns_topic | An SNS topic to publish CloudWatch alarms to | `false` | no |
| db_cluster_parameter_group_name | The name of a DB Cluster parameter group to use | `default.aurora5.6` | no |
| db_parameter_group_name | The name of a DB parameter group to use | `default.aurora5.6` | no |
| envname | Environment name (eg,test, stage or prod) | - | yes |
| envtype | Environment type (eg,prod or nonprod) | - | yes |
| final_snapshot_identifier | The name to use when creating a final snapshot on cluster destroy, appends a random 8 digits to name to ensure it's unique too. | `final_snapshot` | no |
| instance_type | Instance type to use | `db.t2.small` | no |
| monitoring_interval | The interval (seconds) between points when Enhanced Monitoring metrics are collected | `0` | no |
| name | Name given to DB subnet group | - | yes |
| password | Master DB password | - | yes |
| port | The port on which to accept connections | `3306` | no |
| preferred_backup_window | When to perform DB backups | `02:00-03:00` | no |
| preferred_maintenance_window | When to perform DB maintenance | `sun:05:00-sun:06:00` | no |
| publicly_accessible | Whether the DB should have a public IP address | `false` | no |
| replica_count | Number of reader nodes to create | `0` | no |
| security_groups | VPC Security Group IDs | - | yes |
| skip_final_snapshot | Should a final snapshot be created on cluster destroy | `false` | no |
| snapshot_identifier | DB snapshot to create this database from | `` | no |
| storage_encrypted | Specifies whether the underlying storage layer should be encrypted | `true` | no |
| subnets | List of subnet IDs to use | - | yes |
| username | Master DB username | `root` | no |

## Outputs

| Name | Description |
|------|-------------|
| all_instance_endpoints_list | Comma separated list of all DB instance endpoints running in cluster |
| cluster_endpoint | The 'writer' endpoint for the cluster |
| reader_endpoint | A read-only endpoint for the Aurora cluster, automatically load-balanced across replicas |

