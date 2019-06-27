resource "aws_sns_topic" "db_alarms_postgres96" {
  name = "aurora-db-alarms-postgres96"
}

module "aurora_db_postgres96" {
  source                              = "../.."
  engine                              = "aurora-postgresql"
  engine-version                      = "9.6.6"
  name                                = "test-aurora-db-postgres96"
  envname                             = "test-pg96"
  envtype                             = "test"
  subnets                             = module.vpc.private_subnet_ids
  azs                                 = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
  replica_count                       = "1"
  security_groups                     = [aws_security_group.allow_all.id]
  instance_type                       = "db.r4.large"
  username                            = "root"
  password                            = "changeme"
  backup_retention_period             = "5"
  final_snapshot_identifier           = "final-db-snapshot-prod"
  storage_encrypted                   = "true"
  apply_immediately                   = "true"
  monitoring_interval                 = "10"
  cw_alarms                           = true
  cw_sns_topic                        = aws_sns_topic.db_alarms_postgres96.id
  db_parameter_group_name             = aws_db_parameter_group.aurora_db_postgres96_parameter_group.id
  db_cluster_parameter_group_name     = aws_rds_cluster_parameter_group.aurora_cluster_postgres96_parameter_group.id
  iam_database_authentication_enabled = "false"
}

resource "aws_db_parameter_group" "aurora_db_postgres96_parameter_group" {
  name        = "test-aurora-db-postgres96-parameter-group"
  family      = "aurora-postgresql9.6"
  description = "test-aurora-db-postgres96-parameter-group"
}

resource "aws_rds_cluster_parameter_group" "aurora_cluster_postgres96_parameter_group" {
  name        = "test-aurora-postgres96-cluster-parameter-group"
  family      = "aurora-postgresql9.6"
  description = "test-aurora-postgres96-cluster-parameter-group"
}

