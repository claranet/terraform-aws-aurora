resource "aws_sns_topic" "db_alarms_57_autoscaling" {
  name = "aurora-db-alarms-57-autoscaling"
}

module "aurora_db_57_autoscaling" {
  source                              = "../.."
  engine                              = "aurora-mysql"
  engine-version                      = "5.7.12"
  name                                = "aurora-my57-asg"
  envname                             = "test-57-asg"
  envtype                             = "test"
  subnets                             = ["${module.vpc.private_subnets}"]
  azs                                 = ["${module.vpc.availability_zones}"]
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
  cw_sns_topic                        = "${aws_sns_topic.db_alarms_57_autoscaling.id}"
  db_parameter_group_name             = "${aws_db_parameter_group.aurora_db_57_autoscaling_parameter_group.id}"
  db_cluster_parameter_group_name     = "${aws_rds_cluster_parameter_group.aurora_57_autoscaling_cluster_parameter_group.id}"
  replica_scale_enabled               = true
  replica_scale_min                   = "1"
  replica_scale_max                   = "1"
  replica_scale_cpu                   = "70"
  replica_scale_in_cooldown           = "300"
  replica_scale_out_cooldown          = "300"
  iam_database_authentication_enabled = "true"
}

resource "aws_db_parameter_group" "aurora_db_57_autoscaling_parameter_group" {
  name        = "test-aurora-db-57-autoscaling-parameter-group"
  family      = "aurora-mysql5.7"
  description = "test-aurora-db-57-autoscaling-parameter-group"
}

resource "aws_rds_cluster_parameter_group" "aurora_57_autoscaling_cluster_parameter_group" {
  name        = "test-aurora-57-autoscaling-cluster-parameter-group"
  family      = "aurora-mysql5.7"
  description = "test-aurora-57-autoscaling-cluster-parameter-group"
}
