variable "host" {
  type        = string
  description = "The IP address of the target server."
}

variable "user" {
  type        = string
  description = "The user to login with to the target server."
  default     = "root"
}

variable "key" {
  type        = string
  description = "The private key to use when connecting."
  sensitive   = true
}

variable "timeout" {
  type        = number
  description = "How long until timeout on the connection."
  default     = 2000
}
