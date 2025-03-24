resource "hcloud_network" "internal" {
  name     = "internal"
  ip_range = "10.0.0.0/8"
}

resource "hcloud_network_subnet" "k3s_cluster" {
  network_id   = hcloud_network.internal.id
  network_zone = "eu-central"
  type         = "cloud"
  ip_range     = "10.0.1.0/24"
}
