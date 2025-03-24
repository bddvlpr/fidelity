resource "null_resource" "nixos_install" {
  connection {
    type        = "ssh"
    host        = var.host
    user        = var.user
    private_key = var.key
    timeout     = var.timeout
  }

  provisioner "remote-exec" {
    inline = [
      "curl https://raw.githubusercontent.com/elitak/nixos-infect/master/nixos-infect | PROVIDER=hetznercloud NIX_CHANNEL=nixos-24.11 bash 2>&1 | tee /tmp/infect.log"
    ]
  }
}
