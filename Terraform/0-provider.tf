terraform {
  required_providers {
    postgresql = {
      source  = "cyrilgdn/postgresql"
      version = "~> 1.0" # Specify the version you want to use
    }
  }
}

provider "aws" {
  region = "us-east-1"
}
