variable "hcloud_api_token" {
  type        = string
  description = "API token to interact with Hetzner Cloud."
  sensitive   = true
}

variable "k3s_servers" {
  type = map(object({
    ip : string
    type : string
  }))
  default = {
    strawberry : {
      ip   = "10.0.1.2"
      type = "cax11"
    },
  }
}
