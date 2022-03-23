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
    #Actualizar los nodos del cluster
      "echo ${var.pw_root} | sudo -S apt-get update",
      "sudo apt-get install -y curl",

    # Realizamos modificaciones en el fichero /boot/firmware/cmdline.txt
      "if ! grep -qP 'cgroup_enable=memory' /boot/firmware/cmdline.txt; then sudo sed -i.bck '$s/$/ cgroup_enable=memory/' /boot/firmware/cmdline.txt; fi",
      "if ! grep -qP 'cgroup_memory=1' /boot/firmware/cmdline.txt; then sudo sed -i.bck '$s/$/ cgroup_memory=1/' /boot/firmware/cmdline.txt; fi",
      
    # Instalamos microk8s
      "sudo snap install microk8s --classic"
]

}
}