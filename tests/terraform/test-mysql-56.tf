resource "aws_sns_topic" "db_alarms_56" {
  name = "aurora-db-alarms-56"
}

module "aurora_db_56" {
  source                              = "../.."
  name                                = "test-aurora-db-56"
  envname                             = "test56"
  envtype                             = "test"
  subnets                             = ["${module.vpc.private_subnets}"]
  azs                                 = ["${module.vpc.availability_zones}"]
  replica_count                       = "1"
  security_groups                     = ["${aws_security_group.allow_all.id}"]
  instance_type                       = "db.t2.medium"
  username                            = "root"
  password                            = "changeme"
  backup_retention_period             = "5"
  final_snapshot_identifier           = "final-db-snapshot-prod"
  storage_encrypted                   = "true"
  apply_immediately                   = "true"
  monitoring_interval                 = "10"
  cw_alarms                           = true
  cw_sns_topic                        = "${aws_sns_topic.db_alarms_56.id}"
  db_parameter_group_name             = "${aws_db_parameter_group.aurora_db_56_parameter_group.id}"
  db_cluster_parameter_group_name     = "${aws_rds_cluster_parameter_group.aurora_cluster_56_parameter_group.id}"
  iam_database_authentication_enabled = "true"
}

resource "aws_db_parameter_group" "aurora_db_56_parameter_group" {
  name        = "test-aurora-db-56-parameter-group"
  family      = "aurora5.6"
  description = "test-aurora-db-56-parameter-group"
}

resource "aws_rds_cluster_parameter_group" "aurora_cluster_56_parameter_group" {
  name        = "test-aurora-56-cluster-parameter-group"
  family      = "aurora5.6"
  description = "test-aurora-56-cluster-parameter-group"
}
