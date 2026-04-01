terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 5.18"
    }
    null = {
      source = "hashicorp/null"
    }
  }

  required_version = ">= 1.5.0"
}
