resource "null_resource" "cluster_bootstrap_master" {
  for_each = local.master
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
      "sudo snap install microk8s --classic",
    # Damos permisos al usuario
      "sudo usermod -a -G microk8s ${var.user}",
      "sudo chown -f -R ${var.user} ~/.kube",

    # Arrancamos cluster
       "sudo microk8s.start",

    # Creamos masters
      " sudo microk8s add-node | grep 'microk8s join 192.168.1.142' -m 1 >> ~/token",

    # Instalamos helm
       "sudo snap install helm --classic",

    # Añadimos Addons
       "sudo microk8s enable ingress",
       "sudo microk8s enable dashboard",
       "sudo microk8s enable dns",
       "sudo microk8s enable storage",

    # Reiniciamos el sistema
      "sudo shutdown -r +0"
]

}
}

resource "null_resource" "cluster_bootstrap_workers" {
  for_each = local.workers
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
      "sudo snap install microk8s --classic",

    # Unir nodo al cluster como workers  
     # "sudo microk8s join ${var.token} --worker",

   # REiniciamos el sistema
      "sudo shutdown -r +0"
]

}
}