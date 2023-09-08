resource "aws_lb" "onephrase_lb" {
  name               = "onephrase-alb"
  internal           = false
  load_balancer_type = "application"
  subnets            = [ aws_subnet.public.id ]  
  enable_deletion_protection = false  
  enable_http2               = true
}

resource "aws_lb_listener" "https_listener" {
  load_balancer_arn = aws_lb.meu_load_balancer.arn
  port              = 443
  protocol          = "HTTPS"

  ssl_policy      = "ELBSecurityPolicy-2016-08"
  certificate_arn = var.certificate_arn
}

resource "aws_security_group_attachment" "lb_sg_attachment" {
  security_group_id = aws_security_group.load_balancer.id
  lb_arn           = aws_lb.onephrase_lb.arn
}