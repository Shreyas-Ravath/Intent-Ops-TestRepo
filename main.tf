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

# VULNERABLE: Security group with public ingress on port 22
resource "aws_security_group" "test_sg" {
  name        = "intentops-test-sg"
  description = "Test security group for IntentOps demo"
  
  ingress {
    description = "SSH from restricted ranges"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/8", "172.16.0.0/12"]  # Modified by IntentOps to fix INTENT-NET-001
  }
  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  tags = {
    Name = "intentops-test-sg"
  }
}
#testdemo-2
resource "aws_security_group" "test_sg2" {
  name        = "intentops-test-sg-2"
  description = "Test security group for IntentOps demo"
  
  ingress {
    description = "SSH from restricted ranges"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Modified by IntentOps to fix INTENT-NET-001
  }
  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  tags = {
    Name = "intentops-test-sg2"
  }
}
output "security_group_id" {
  value = aws_security_group.test_sg.id
}

output "security_group_id-2" {
  value = aws_security_group.test_sg2.id
}
