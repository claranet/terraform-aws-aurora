resource "aws_sns_topic" "db_alarms" {
  name = "aurora-db-alarms"
}

module "aurora_db_57" {
  source                          = "../.."
  engine                          = "aurora-mysql"
  engine-version                  = "5.7.12"
  name                            = "test-aurora-db-57"
  envname                         = "test-57"
  envtype                         = "test"
  subnets                         = ["${module.vpc.private_subnets}"]
  azs                             = ["${module.vpc.availability_zones}"]
  replica_count                   = "1"
  security_groups                 = ["${aws_security_group.allow_all.id}"]
  instance_type                   = "db.t2.medium"
  username                        = "root"
  password                        = "changeme"
  backup_retention_period         = "5"
  final_snapshot_identifier       = "final-db-snapshot-prod"
  storage_encrypted               = "true"
  apply_immediately               = "true"
  monitoring_interval             = "10"
  cw_alarms                       = true
  cw_sns_topic                    = "${aws_sns_topic.db_alarms.id}"
  db_parameter_group_name         = "${aws_db_parameter_group.aurora_db_57_parameter_group.id}"
  db_cluster_parameter_group_name = "${aws_rds_cluster_parameter_group.aurora_57_cluster_parameter_group.id}"
}

resource "aws_db_parameter_group" "aurora_db_57_parameter_group" {
  name        = "test-aurora-db-57-parameter-group"
  family      = "aurora-mysql5.7"
  description = "test-aurora-db-57-parameter-group"
}

resource "aws_rds_cluster_parameter_group" "aurora_57_cluster_parameter_group" {
  name        = "test-aurora-57-cluster-parameter-group"
  family      = "aurora-mysql5.7"
  description = "test-aurora-57-cluster-parameter-group"
}
