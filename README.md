tf-aws-aurora
---------

AWS Aurora DB Cluster & Instance(s) Terraform Module.

Gives you:

 - A DB subnet group
 - An Aurora DB cluster
 - An Aurora DB instance + 'n' number of additional instances
 - Optionally RDS 'Enhanced Monitoring' + associated required IAM role/policy (by simply setting the `monitoring_interval` param to > `0`
 - Optionally sensible alarms to SNS (high CPU, high connections, slow replication)


## Contributing

Ensure any variables you add have a type and a description, and a default if appropriate.


Usage example
---------

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


Inputs
---------
_Variables marked with __[*]__ are mandatory._

###### Environment
 - `envname` - Environment name (e.g. `test`, `staging`). __[*]__
 - `envtype` - Environment type (e.g. `prod`, `nonprod`). __[*]__
 - `azs` - List of AZs to use. __[*]__

###### Cloudwatch variables
 - `cw_alarms` - Whether to enable CloudWatch alarms - requires `cw_sns_topic` is specified. [Default: `false`]
 - `cw_sns_topic` - An SNS topic to publish CloudWatch alarms to. [__*__ unless `cw_alarms` is `false`]
 - `cw_max_conns` - Connection count beyond which to trigger a CloudWatch alarm. [Default: `500`]
 - `cw_max_cpu` - CPU threshold above which to alarm. [Default: `85`]
 - `cw_max_replica_lag` - Maximum Aurora replica lag in milliseconds above which to alarm. [Default: `2000`]

###### Instance and Network 
 - `instance_type` - Instance type to use. [Default: `db.t2.small`]
 - `name` - Name given to DB subnet group. __[*]__
 - `subnets` - List of subnet IDs to use. __[*]__
 - `publicly_accessible` - Whether the DB should have a public IP address. [Default: `false`]
 - `security_groups` - VPC Security Group IDs. __[*]__

###### Aurora variables
 - `username` - Master DB username. [Default: `root`]
 - `password` - Master DB password. __[*]__
 - `port` - The port on which to accept connections. [Default: `3306`]
 - `replica_count` - Number of reader nodes to create. [Default: `0`]
 - `storage_encrypted` - Specifies whether the underlying storage layer should be encrypted. [Default: `true`]
 - `db_cluster_parameter_group_name` - The name of a DB Cluster parameter group to use. [Default: `default.aurora5.6`]
 - `db_parameter_group_name` - The name of a DB parameter group to use. [Default: `default.aurora5.6`]
 - `monitoring_interval` - The interval (seconds) between points when Enhanced Monitoring metrics are collected. [Default: `0`]
 - `backup_retention_period` - How long to keep backups for (in days). [Default: `7`]

###### Backup, maintenance and snapshots
 - `preferred_backup_window` - When to perform DB backups. [Default: `02:00-03:00`]
 - `preferred_maintenance_window` - When to perform DB maintenance. [Default: `sun:05:00-sun:06:00`]
 - `skip_final_snapshot` - Should a final snapshot be created on cluster destroy. [Default: `false`]
 - `snapshot_identifier` - DB snapshot to create this database from. [Default: '']
 - `final_snapshot_identifier` - The name to use when creating a final snapshot on cluster destroy, appends a random 8 digits to name to ensure it's unique too. [Default: `final_snapshot`]
 - `apply_immediately` - Determines whether or not any DB modifications are applied immediately, or during the maintenance window. [Default: `false`]
 - `auto_minor_version_upgrade` - Determines whether minor engine upgrades will be performed automatically in the maintenance window. [Default: `false`]

Outputs
---------

 - `all_instance_endpoints_list` - Comma separated list of all DB instance endpoints running in cluster.
 - `cluster_endpoint` - The 'writer' endpoint for the cluster.
 - `reader_endpoint` - A read-only endpoint for the Aurora cluster, automatically load-balanced across replicas.
