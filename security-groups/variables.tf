variable "region" {}

variable "remote_state_bucket_name" {
  description = "Terraform remote state bucket name"
}

variable depends_on {
  default = []
  type    = "list"
}

variable "user_access_cidr_blocks" {
  type = "list"
}

variable "psn_proxy_cidrs" {
  description = "Fixed IP for IAPS PSN Proxy"
  type = "list"
  default = [
    "3.10.56.113/32",    # PSN Proxies
    "81.134.202.29/32",  # Moj VPN
  ]
}
