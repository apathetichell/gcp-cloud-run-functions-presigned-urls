terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "=6.22.0"
    }
/*
##AWS is included only if you want to set up a backend with an AWS S3 bucket - otherwise it is not needed.
     aws = {
      source  = "hashicorp/aws"
      version = ">= 5.8.0"
    }
*/
  }
  required_version = "~> 1.7"
}
