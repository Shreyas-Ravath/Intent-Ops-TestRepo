terraform {
  backend "s3" {
    bucket = "intentops-test-tfstate-365580293637"
    key    = "test/terraform.tfstate"
    region = "us-east-1"
  }
}

provider "aws" {
  region = "us-east-1"
  
  default_tags {
    tags = {
      GitRepository = "https://github.com/Shreyas-Ravath/Intent-Ops-TestRepo"
      ManagedBy     = "terraform"
      Environment   = "dev"
    }
  }
}

variable vpc_id {
default = "vpc-0d2feda38007c22aa"
}
