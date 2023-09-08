resource "aws_lb" "onephrase_lb" {
  name               = "onephrase-alb"
  internal           = false
  load_balancer_type = "application"
  subnets            = [ aws_subnet.public.id, aws_subnet.public_2.id ]  
  security_groups    = [ aws_security_group.load_balancer.id ]
  enable_deletion_protection = false  
  enable_http2               = true
}

resource "aws_lb_listener" "https_listener" {
  load_balancer_arn = aws_lb.onephrase_lb.arn
  port              = 443
  protocol          = "HTTPS"

  ssl_policy      = "ELBSecurityPolicy-2016-08"
  certificate_arn = var.certificate_arn

  default_action {
    type           = "fixed-response"
    
    fixed_response {
      content_type = "text/plain"
      message_body = "Not found."
      status_code  = "404"
    }
  }
}

resource "aws_lb_target_group" "onephrase" {
  name        = "nginx-onephrase"
  port        = 80
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = aws_vpc.main.id
}

resource "aws_lb_target_group_attachment" "onephrase_nginx" {
  target_group_arn = aws_lb_target_group.onephrase.arn
  target_id        = aws_instance.nginx.id
  port             = 80
}

resource "aws_lb_listener_rule" "host_based_routing" {
  listener_arn = aws_lb_listener.https_listener.arn
  priority     = 1

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.onephrase.arn
  }

  condition {
    host_header {
      values = [ var.api_servername ]
    }
  }
}

