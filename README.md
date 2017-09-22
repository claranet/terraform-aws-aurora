# tf-aws-aurora

AWS Aurora DB Cluster & Instance(s) Terraform Module.

Gives you:

 - A DB subnet group
 - An Aurora DB cluster
 - An Aurora DB instance + 'n' number of additional instances
 - Optionally RDS 'Enhanced Monitoring' + associated required IAM role/policy (by simply setting the `monitoring_interval` param to > `0`

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

## Variables

Variables marked with an * are mandatory, the others have sane defaults and can be omitted.

* `name`\* - Name given to DB subnet group
* `subnets`\* - List of subnet IDs to use
* `envname`\* - Environment name (eg,test, stage or prod)
* `envtype`\* - Environment type (eg,prod or nonprod)
* `azs`\* - List of AZs to use
* `replica_count`\ - Number of additional DB nodes to create (default: `0` )
* `security_groups`\* - List of security groups to use
* `instance_type` - Instance type to use for DBs (default: `db.t2.small`)
* `publicly_accessible` - Should the DB be publicly accessible or not (default: `false` )
* `username` - Master DB username (default: `root` )
* `password`\* - Master DB password
* `final_snapshot_indentifier` - The name to use when creating a final snapshot on cluster destroy (default: `final_snapshot` ), appends a random 8 digits to name to ensure it's unique too.
* `skip_final_snapshot` - Should a final snapshot be created on cluster destroy (default: `false` )
* `backup_retention_period` - How long to keep DB backups for (default: `0` )
* `preferred_backup_window` - When to perform DB backups (default: `02:00-03:00` )
* `preferred_maintenance_window` - When to perform DB maintenance (default: `sun:05:00-sun:06:00` )
* `port` - The port on which to accept connections (default: `3306` )
* `apply_immediately` - Determines whether or not any DB modifications are applied immediately, or during the maintenance window (default: `false` )
* `monitoring_interval` - The interval (seconds) between points when Enhanced Monitoring metrics are collected (default: `0` ) - valid values: `0`, `1`, `5`, `10`, `15`, `30`, `60`
* `auto_minor_version_upgrade` - Determines whether minor engine upgrades will be performed automatically in the maintenance window (default: `false` )
* `db_parameter_group_name` - The name of DB parameter group to use (default: `default.aurora5.6` )
* `db_cluster_parameter_group_name` - The name of DB Cluster parameter group to use (default: `default.aurora5.6` )
* `snapshot_identifier` - Specifies whether or not to create this cluster from an existing snapshot (default: `""` )
* `storage_encrypted` - Specifies whether the underlying storage layer should be encrypted (default: `true` )
* `cw_alarms` - Whether to create CloudWatch alarms - you must also specify
    `cw_sns_topic` when enabling (default: `false`)
* `cw_sns_topic` - An SNS topic to publish CloudWatch alarms to, required for all
    other `cw` prefixed options
* `cw_max_conns` - Connection count beyond which to trigger a CloudWatch alarm (default: `500`)
* `cw_max_cpu` - CPU threshold above which to alarm (default: `85`%)
* `cw_max_replica_lag` - Maximum Aurora replica lag in milliseconds above which to alarm (default: `2000`)

## Outputs

* `cluster_endpoint` - The 'writer' endpoint for the cluster
* `all_instance_endpoints_list` - Comma separated list of all DB instance endpoints running in cluster
* `reader_endpoint` - A read-only endpoint for the Aurora cluster, automatically load-balanced across replicas
