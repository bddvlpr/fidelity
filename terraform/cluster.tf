resource "hcloud_ssh_key" "user_keys" {
  for_each   = local.all_keys
  name       = each.key
  public_key = each.value
}

resource "hcloud_server" "cluster_servers" {
  for_each    = var.k3s_servers
  name        = each.key
  server_type = each.value.type
  image       = "debian-12"
  location    = "hel1"
  ssh_keys    = keys(local.all_keys)

  network {
    network_id = hcloud_network.internal.id
    ip         = each.value.ip
  }

  public_net {
    ipv4_enabled = true
    ipv6_enabled = true
  }

  depends_on = [
    hcloud_network_subnet.k3s_cluster
  ]
}

module "nixos_install" {
  source   = "./modules/nixos-install"
  for_each = hcloud_server.cluster_servers
  host     = each.value.ipv4_address
  key      = file("~/.ssh/id_ed25519")
}
