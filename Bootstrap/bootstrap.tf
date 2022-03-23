resource "null_resource" "cluster_bootstrap" {
  for_each = local.nodes
  connection {
    type        = "ssh"
    user        = var.user
    private_key = file("~/.ssh/${var.key}")
    host        = each.value.ip_addr
  }


provisioner "remote-exec" {
inline = [
      "echo ${var.pw_root} | sudo -S apt-get update",
      "sudo apt-get install -y curl",
]

}
}