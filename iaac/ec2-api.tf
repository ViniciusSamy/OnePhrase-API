resource "aws_instance" "api" {
  ami             = "ami-053b0d53c279acc90" 
  instance_type   = "t2.micro" 
  key_name        = aws_key_pair.onephras_key.key_name  
  security_groups = [ aws_security_group.api.id ]
  subnet_id       = aws_subnet.public.id
  user_data       = file("ec2-userdata/ec2-api.sh")


  tags = {
    Name = "NodeAPI - OnePhrase"  
  }
}