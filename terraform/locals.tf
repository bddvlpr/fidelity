locals {
  users = {
    bddvlpr : {
      ssh_keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEgZVPZ2+cqT1seskNMDRtb8x+W6XkJBl9w8ZkqzkWP8 bddvlpr@dissension",
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBtNqtIZtEaty6EAPwKQj5s0AxUfaJaCrQYeEaWFtqM/ bddvlpr@solaris",
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKdRlPLeVFbEwSszVTzYsN08c+k+jBYAzHJPLsKPm6Jg bddvlpr@lavender"
      ]
    }
  }

  all_keys = merge(
    [for user, data in local.users :
      { for idx, key in data.ssh_keys : "${user}-${idx}" => key }
    ]...
  )
}
