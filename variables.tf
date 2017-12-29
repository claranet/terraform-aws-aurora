variable "name" {
  type        = "string"
  description = "Name given to DB subnet group"
}

variable "subnets" {
  type        = "list"
  description = "List of subnet IDs to use"
}

variable "envname" {
  type        = "string"
  description = "Environment name (eg,test, stage or prod)"
}

variable "envtype" {
  type        = "string"
  description = "Environment type (eg,prod or nonprod)"
}

variable "identifier_prefix" {
	type = "string"
	default = ""
	description = "Prefix for cluster and instance identifier"
}

variable "azs" {
  type        = "list"
  description = "List of AZs to use"
}

variable "replica_count" {
  type        = "string"
  default     = "0"
  description = "Number of reader nodes to create"
}

variable "security_groups" {
  type        = "list"
  description = "VPC Security Group IDs"
}

variable "instance_type" {
  type        = "string"
  default     = "db.t2.small"
  description = "Instance type to use"
}

variable "publicly_accessible" {
  type        = "string"
  default     = "false"
  description = "Whether the DB should have a public IP address"
}

variable "username" {
  default     = "root"
  description = "Master DB username"
}

variable "password" {
  type        = "string"
  description = "Master DB password"
}

variable "final_snapshot_identifier" {
  type        = "string"
  default     = "final"
  description = "The name to use when creating a final snapshot on cluster destroy, appends a random 8 digits to name to ensure it's unique too."
}

variable "skip_final_snapshot" {
  type        = "string"
  default     = "false"
  description = "Should a final snapshot be created on cluster destroy"
}

variable "backup_retention_period" {
  type        = "string"
  default     = "7"
  description = "How long to keep backups for (in days)"
}

variable "preferred_backup_window" {
  type        = "string"
  default     = "02:00-03:00"
  description = "When to perform DB backups"
}

variable "preferred_maintenance_window" {
  type        = "string"
  default     = "sun:05:00-sun:06:00"
  description = "When to perform DB maintenance"
}

variable "port" {
  type        = "string"
  default     = "3306"
  description = "The port on which to accept connections"
}

variable "apply_immediately" {
  type        = "string"
  default     = "false"
  description = "Determines whether or not any DB modifications are applied immediately, or during the maintenance window"
}

variable "monitoring_interval" {
  type        = "string"
  default     = 0
  description = "The interval (seconds) between points when Enhanced Monitoring metrics are collected"
}

variable "auto_minor_version_upgrade" {
  type        = "string"
  default     = "true"
  description = "Determines whether minor engine upgrades will be performed automatically in the maintenance window"
}

variable "db_parameter_group_name" {
  type        = "string"
  default     = "default.aurora5.6"
  description = "The name of a DB parameter group to use"
}

variable "db_cluster_parameter_group_name" {
  type        = "string"
  default     = "default.aurora5.6"
  description = "The name of a DB Cluster parameter group to use"
}

variable "snapshot_identifier" {
  type        = "string"
  default     = ""
  description = "DB snapshot to create this database from"
}

variable "storage_encrypted" {
  type        = "string"
  default     = "true"
  description = "Specifies whether the underlying storage layer should be encrypted"
}

variable "cw_alarms" {
  type        = "string"
  default     = false
  description = "Whether to enable CloudWatch alarms - requires `cw_sns_topic` is specified"
}

variable "cw_sns_topic" {
  type        = "string"
  default     = "false"
  description = "An SNS topic to publish CloudWatch alarms to"
}

variable "cw_max_conns" {
  type        = "string"
  default     = "500"
  description = "Connection count beyond which to trigger a CloudWatch alarm"
}

variable "cw_max_cpu" {
  type        = "string"
  default     = "85"
  description = "CPU threshold above which to alarm"
}

variable "cw_max_replica_lag" {
  type        = "string"
  default     = "2000"
  description = "Maximum Aurora replica lag in milliseconds above which to alarm"
}
