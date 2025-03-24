terraform {
  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "~> 1.45"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 5"
    }
  }

  cloud {
    organization = "bddvlpr"
    workspaces {
      name = "fidelity"
    }
  }
}

provider "hcloud" {
  token = var.hcloud_api_token
}
