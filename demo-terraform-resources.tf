# IntentOps Demo Resources
# These three security groups demonstrate different decision outcomes

# Resource 1: CREATE_PR - High confidence violation
# Production environment with clear unrestricted SSH access
resource "aws_security_group" "demo_create_pr" {
  name        = "intentops-demo-create-pr"
  description = "Demo SG that should trigger CREATE_PR decision"
  vpc_id      = var.vpc_id  # Replace with actual VPC ID

  # VIOLATION: Unrestricted SSH access from internet
  ingress {
    description = "SSH from anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Legitimate HTTPS access
  ingress {
    description = "HTTPS from anywhere"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name                = "intentops-demo-create-pr"
    Environment         = "prod"
    ManagedBy           = "terraform"
    Application         = "web-frontend"
    Owner               = "platform-team"
    IntentOpsDemo       = "create-pr"
  }
}

# Resource 2: REPORT_ONLY - Dev environment (out of policy scope)
# Same violation but in dev environment, policy only applies to prod
resource "aws_security_group" "demo_report_only" {
  name        = "intentops-demo-report-only"
  description = "Demo SG that should trigger REPORT_ONLY decision"
  vpc_id      = var.vpc_id  # Replace with actual VPC ID

  # VIOLATION: Unrestricted SSH access from internet
  ingress {
    description = "SSH from anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Legitimate HTTP access
  ingress {
    description = "HTTP from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name                = "intentops-demo-report-only"
    Environment         = "dev"
    ManagedBy           = "terraform"
    Application         = "test-app"
    Owner               = "dev-team"
    IntentOpsDemo       = "report-only"
  }
}

# Resource 3: ESCALATE - Ambiguous situation
# Production but with unclear/complex configuration
resource "aws_security_group" "demo_escalate" {
  name        = "intentops-demo-escalate"
  description = "Demo SG that should trigger ESCALATE decision"
  vpc_id      = var.vpc_id  # Replace with actual VPC ID

  # VIOLATION: Unrestricted RDP access (less common, might be intentional)
  ingress {
    description = "RDP from anywhere"
    from_port   = 3389
    to_port     = 3389
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Multiple other ports that might be legitimate
  ingress {
    description = "Custom application port"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name                = "intentops-demo-escalate"
    Environment         = "prod"
    ManagedBy           = "terraform"
    Application         = "legacy-windows-app"
    Owner               = "legacy-team"
    IntentOpsDemo       = "escalate"
    # Missing clear ownership information
  }
}

# Outputs for reference
output "create_pr_sg_id" {
  description = "Security Group ID for CREATE_PR demo"
  value       = aws_security_group.demo_create_pr.id
}

output "report_only_sg_id" {
  description = "Security Group ID for REPORT_ONLY demo"
  value       = aws_security_group.demo_report_only.id
}

output "escalate_sg_id" {
  description = "Security Group ID for ESCALATE demo"
  value       = aws_security_group.demo_escalate.id
}
