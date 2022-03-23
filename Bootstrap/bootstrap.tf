resource "null_resource" "cluster_bootstrap" {
  for_each = local.nodes
  connection {
    type        = "ssh"
    user        = var.user
    private_key = file("~/.ssh/${var.private_key}")
    host        = each.value.ip_addr
  }
}