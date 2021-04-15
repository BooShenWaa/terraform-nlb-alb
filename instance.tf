resource "aws_instance" "nginx" {
  ami                    = "ami-0fbec3e0504ee1970"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.web_server.id]
  key_name               = "KP2021"
  subnet_id = aws_subnet.public.id
  user_data = file("apache.sh")

  tags = {
    Name = "Nginx"
  }
}

resource "aws_eip" "ip" {
  instance = aws_instance.nginx.id
}