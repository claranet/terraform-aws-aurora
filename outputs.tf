// The 'writer' endpoint for the cluster
output "cluster_endpoint" {
  value = join("", aws_rds_cluster.default.*.endpoint)
}

// List of all DB instance endpoints running in cluster
output "all_instance_endpoints_list" {
  value = [concat(
    aws_rds_cluster_instance.cluster_instance_0.*.endpoint,
    aws_rds_cluster_instance.cluster_instance_n.*.endpoint,
  )]
}

// A read-only endpoint for the Aurora cluster, automatically load-balanced across replicas
output "reader_endpoint" {
  value = join("", aws_rds_cluster.default.*.reader_endpoint)
}

// The ID of the RDS Cluster
output "cluster_identifier" {
  value = join("", aws_rds_cluster.default.*.id)
}

// List of all DB instance ids running in cluster
output "all_instance_endpoints_list" {
  value = [concat(
    aws_rds_cluster_instance.cluster_instance_0.*.id,
    aws_rds_cluster_instance.cluster_instance_n.*.id,
  )]
}
