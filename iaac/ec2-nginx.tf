resource "aws_eip" "nginx" {
  instance = aws_instance.nginx.id
  domain   = "vpc"
}

resource "aws_instance" "nginx" {
  ami             = "ami-053b0d53c279acc90" 
  instance_type   = "t2.micro" 
  key_name        = aws_key_pair.onephras_key.key_name  
  security_groups = [ aws_security_group.nginx.id ]
  subnet_id       = aws_subnet.public.id
  user_data       = file("ec2-userdata/ec2-nginx.sh")


  tags = {
    Name = "NodeAPI - OnePhrase"  
  }
}