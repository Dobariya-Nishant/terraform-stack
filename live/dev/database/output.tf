output "docdb" {
  value = {
    cluster_id        = module.docdb.cluster_id
    endpoint          = module.docdb.endpoint
    connection_string = module.docdb.connection_string
  }
  sensitive = true
}