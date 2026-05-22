data "aws_ami" "latest_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.x-x86_64*"] # Amazon Linux 2023
  }
}

# Provision 5 t2.xlarge instances
resource "aws_instance" "app_server" {
  count         = 5
  ami           = data.aws_ami.latest_linux.id
  instance_type = "t2.xlarge"
  key_name      = "your-ssh-key-name" # Replace with your EC2 Key Pair

  # Optional: Assign specific tags, names, or attach a security group
  tags = {
    Name = "App-Server-${count.index + 1}" # Gives each instance a unique name
  }
