variable "name" {}

variable "subnets" {
  type = "list"
}

variable "envname" {}

variable "envtype" {}

variable "azs" {
  type = "list"
}

variable "replica_count" {
  default = "0"
}

variable "security_groups" {
  type        = "list"
  description = "VPC Security Group IDs"
}

variable "instance_type" {
  default = "db.t2.small"
}

variable "publicly_accessible" {
  default = "false"
}

variable "username" {
  default = "root"
}

variable "password" {}

variable "final_snapshot_identifier" {
  default = "final_snapshot"
}

variable "skip_final_snapshot" {
  default = "false"
}

variable "backup_retention_period" {
  default = "0"
}

variable "preferred_backup_window" {
  default = "02:00-03:00"
}

variable "preferred_maintenance_window" {
  default = "sun:05:00-sun:06:00"
}

variable "port" {
  default = "3306"
}

variable "apply_immediately" {
  default = "false"
}

variable "monitoring_interval" {
  default = 0
}

variable "auto_minor_version_upgrade" {
  default = "false"
}

variable "db_parameter_group_name" {
  default = "default.aurora5.6"
}

variable "db_cluster_parameter_group_name" {
  default = "default.aurora5.6"
}

variable "snapshot_identifier" {
  default = ""
}

variable "storage_encrypted" {
  default = "true"
}

variable "cw_alarms" {
  default = false
}

variable "cw_sns_topic" {
  default = "false"
}

variable "cw_max_conns" {
  default = "500"
}

variable "cw_max_cpu" {
  default = "85"
}

variable "cw_max_replica_lag" {
  default = "2000"
}
