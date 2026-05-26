data "aws_ami" "amzlinux" {
  most_recent = true
  owners = [ "amazon" ]
  filter {
    name = "name"
    values = [ "amzn2-ami-hvm-*-gp2" ]
  }
  filter {
    name = "root-device-type"
    values = [ "ebs" ]
  }
  filter {
    name = "virtualization-type"
    values = [ "hvm" ]
  }
  filter {
    name = "architecture"
    values = [ "x86_64" ]
  }
}

# Provision 5 t2.xlarge instances
resource "aws_instance" "app_server" {
  count         = 1
  ami           = data.aws_ami.amzlinux.id
  instance_type = "t3.small"
  key_name      = "your-ssh-key-name" # Replace with your EC2 Key Pair

  # Optional: Assign specific tags, names, or attach a security group
  tags = {
    Name = "App-Server-${count.index + 1}" # Gives each instance a unique name
  }
}
