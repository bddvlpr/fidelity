resource "hcloud_firewall" "firewall_icmp" {
  name = "firewall-imcp"
  rule {
    direction  = "in"
    protocol   = "icmp"
    source_ips = [hcloud_network.internal.ip_range]
  }
}

resource "hcloud_firewall" "firewall_ssh" {
  name = "firewall-ssh"
  rule {
    direction  = "in"
    protocol   = "tcp"
    port       = 22
    source_ips = ["0.0.0.0/0"]
  }
}

resource "hcloud_firewall" "firewall_k3s" {
  name = "firewall-k3s"
  rule {
    direction = "in"
    protocol  = "tcp"
    port      = 6443
    source_ips = [
      hcloud_network_subnet.k3s_cluster.ip_range
    ]
  }
}
