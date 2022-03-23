# Definicion variables de entrada
variable "pw_root" {}
variable "user" {}
variable "key" {}

locals {
  nodes = {
    Kubemaster = {
      hostname = "Kubemaster"
      ip_addr  = "192.168.1.142"
      role     = ["controlplane", "worker", "etcd"]
    ,
    node01 = {
      hostname = "Kubenode01"
      ip_addr  = "192.168.1.139"
      role     = ["worker", "etcd"]
    }
  }

}