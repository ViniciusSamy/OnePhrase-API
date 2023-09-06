resource "aws_security_group" "load_balancer" {
  name        = "load-balancer-sg"
  description = "Expose load balancer to internet"
  vpc_id      = aws_vpc.main.id

  ingress {
    description      =  "Allow http requests"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description      =  "Allow https requests"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "load-balancer-sg"
  }
}

resource "aws_security_group" "nginx" {
  name        = "nginx-sg"
  description = "Allow traffic from load balancer to nginx"
  vpc_id      = aws_vpc.main.id


  ingress {
    description      = "Expose nginx to load balancer"
    from_port        = var.ports["nginx"]
    to_port          = var.ports["nginx"]
    protocol         = "tcp"
    security_groups = [ aws_security_group.load_balancer.id ]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "nginx-sg"
  }
}


resource "aws_security_group" "api" {
  name        = "api-sg"
  description = "Expose api to nginx"
  vpc_id      = aws_vpc.main.id

  ingress {
    description      = "Allow access to API from NGinX"
    from_port        = var.ports["api"]
    to_port          = var.ports["api"]
    protocol         = "tcp"
    security_groups = [ aws_security_group.nginx.id ]
  }

  ingress {
    description      = "Expose API to internet"
    from_port        = var.ports["api"]
    to_port          = var.ports["api"]
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "api-sg"
  }
}


