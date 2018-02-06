/**
  * # tf-aws-aurora
  *
  * AWS Aurora DB Cluster & Instance(s) Terraform Module.
  *
  * Gives you:
  *
  *  - A DB subnet group
  *  - An Aurora DB cluster
  *  - An Aurora DB instance + 'n' number of additional instances
  *  - Optionally RDS 'Enhanced Monitoring' + associated required IAM role/policy (by simply setting the `monitoring_interval` param to > `0`
  *  - Optionally sensible alarms to SNS (high CPU, high connections, slow replication)
  *
  *
  * ## Contributing
  *
  * Ensure any variables you add have a type and a description.
  * This README is generated with [terraform-docs](https://github.com/segmentio/terraform-docs):
  *
  * `terraform-docs md . > README.md`
  *
  * ## Usage example
  *
  * ```
  * resource "aws_sns_topic" "db_alarms" {
  *   name = "aurora-db-alarms"
  * }
  *
  * module "aurora_db" {
  *   source                    = "../.."
  *   name                      = "test-aurora-db"
  *   envname                   = "test"
  *   envtype                   = "test"
  *   subnets                   = ["${module.vpc.private_subnets}"]
  *   azs                       = ["${module.vpc.availability_zones}"]
  *   replica_count             = "1"
  *   security_groups           = ["${aws_security_group.allow_all.id}"]
  *   instance_type             = "db.t2.medium"
  *   username                  = "root"
  *   password                  = "changeme"
  *   backup_retention_period   = "5"
  *   final_snapshot_identifier = "final-db-snapshot-prod"
  *   storage_encrypted         = "true"
  *   apply_immediately         = "true"
  *   monitoring_interval       = "10"
  *   cw_alarms                 = true
  *   cw_sns_topic              = "${aws_sns_topic.db_alarms.id}"
  * }
  * ```
  *
  * These additional parameters need specifing for a PostgreSQL instance:
  * ```
  * module "aurora_db" {
  *   ...
  *   instance_type                   = "db.r4.large"
  *   engine                          = "aurora-postgresql"
  *   port                            = 5432
  *   db_parameter_group_name         = "default.aurora-postgresql9.6"
  *   db_cluster_parameter_group_name = "default.aurora-postgresql9.6"
  *   ...
  * }
  * ```
*/

// DB Subnet Group creation
resource "aws_db_subnet_group" "main" {
  name        = "${var.name}"
  description = "Group of DB subnets"
  subnet_ids  = ["${var.subnets}"]

  tags {
    envname = "${var.envname}"
    envtype = "${var.envtype}"
  }
}

// Create single DB instance
resource "aws_rds_cluster_instance" "cluster_instance_0" {
  identifier                   = "${var.identifier_prefix != "" ? format("%s-node-0", var.identifier_prefix) : format("%s-aurora-node-0", var.envname)}"
  cluster_identifier           = "${aws_rds_cluster.default.id}"
  engine                       = "${var.engine}"
  instance_class               = "${var.instance_type}"
  publicly_accessible          = "${var.publicly_accessible}"
  db_subnet_group_name         = "${aws_db_subnet_group.main.name}"
  db_parameter_group_name      = "${var.db_parameter_group_name}"
  preferred_maintenance_window = "${var.preferred_maintenance_window}"
  apply_immediately            = "${var.apply_immediately}"
  monitoring_role_arn          = "${join("", aws_iam_role.rds-enhanced-monitoring.*.arn)}"
  monitoring_interval          = "${var.monitoring_interval}"
  auto_minor_version_upgrade   = "${var.auto_minor_version_upgrade}"
  promotion_tier               = "0"

  tags {
    envname = "${var.envname}"
    envtype = "${var.envtype}"
  }
}

// Create 'n' number of additional DB instance(s) in same cluster
resource "aws_rds_cluster_instance" "cluster_instance_n" {
  depends_on                   = ["aws_rds_cluster_instance.cluster_instance_0"]
  count                        = "${var.replica_count}"
  engine                       = "${var.engine}"
  identifier                   = "${var.identifier_prefix != "" ? format("%s-node-%d", var.identifier_prefix, count.index + 1) : format("%s-aurora-node-%d", var.envname, count.index + 1)}"
  cluster_identifier           = "${aws_rds_cluster.default.id}"
  instance_class               = "${var.instance_type}"
  publicly_accessible          = "${var.publicly_accessible}"
  db_subnet_group_name         = "${aws_db_subnet_group.main.name}"
  db_parameter_group_name      = "${var.db_parameter_group_name}"
  preferred_maintenance_window = "${var.preferred_maintenance_window}"
  apply_immediately            = "${var.apply_immediately}"
  monitoring_role_arn          = "${join("", aws_iam_role.rds-enhanced-monitoring.*.arn)}"
  monitoring_interval          = "${var.monitoring_interval}"
  auto_minor_version_upgrade   = "${var.auto_minor_version_upgrade}"
  promotion_tier               = "${count.index + 1}"

  tags {
    envname = "${var.envname}"
    envtype = "${var.envtype}"
  }
}

// Create DB Cluster
resource "aws_rds_cluster" "default" {
  cluster_identifier              = "${var.identifier_prefix != "" ? format("%s-cluster", var.identifier_prefix) : format("%s-aurora-cluster", var.envname)}"
  availability_zones              = ["${var.azs}"]
  engine                          = "${var.engine}"
  master_username                 = "${var.username}"
  master_password                 = "${var.password}"
  final_snapshot_identifier       = "${var.final_snapshot_identifier}-${random_id.server.hex}"
  skip_final_snapshot             = "${var.skip_final_snapshot}"
  backup_retention_period         = "${var.backup_retention_period}"
  preferred_backup_window         = "${var.preferred_backup_window}"
  preferred_maintenance_window    = "${var.preferred_maintenance_window}"
  port                            = "${var.port}"
  db_subnet_group_name            = "${aws_db_subnet_group.main.name}"
  vpc_security_group_ids          = ["${var.security_groups}"]
  snapshot_identifier             = "${var.snapshot_identifier}"
  storage_encrypted               = "${var.storage_encrypted}"
  apply_immediately               = "${var.apply_immediately}"
  db_cluster_parameter_group_name = "${var.db_cluster_parameter_group_name}"
}

// Geneate an ID when an environment is initialised
resource "random_id" "server" {
  keepers = {
    id = "${aws_db_subnet_group.main.name}"
  }

  byte_length = 8
}

// IAM Role + Policy attach for Enhanced Monitoring
data "aws_iam_policy_document" "monitoring-rds-assume-role-policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["monitoring.rds.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "rds-enhanced-monitoring" {
  count              = "${var.monitoring_interval > 0 ? 1 : 0}"
  name               = "rds-enhanced-monitoring-${var.envname}"
  assume_role_policy = "${data.aws_iam_policy_document.monitoring-rds-assume-role-policy.json}"
}

resource "aws_iam_role_policy_attachment" "rds-enhanced-monitoring-policy-attach" {
  count      = "${var.monitoring_interval > 0 ? 1 : 0}"
  role       = "${aws_iam_role.rds-enhanced-monitoring.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
}
