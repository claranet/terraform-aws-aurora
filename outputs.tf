output "cluster_endpoint" {
  value = "${aws_rds_cluster.default.endpoint}"
}

output "all_instance_endpoints_list" {
  value = ["${aws_rds_cluster_instance.cluster_instance_0.endpoint}", "${aws_rds_cluster_instance.cluster_instance_n.*.endpoint}"]
}

output "reader_endpoint" {
  value = "${aws_rds_cluster.default.reader_endpoint}"
}
