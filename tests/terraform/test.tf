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
