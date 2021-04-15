resource "aws_lb" "nlb" {
  name = "NLB"
  internal = false
  load_balancer_type = "network"
  subnets = [ aws_subnet.public.id, aws_subnet.public2.id ]

  tags = {
    Name = "NLB"
  }
}

resource "aws_lb_listener" "nlb-listener-tcp" {
  load_balancer_arn = aws_lb.nlb.arn
  protocol = "TCP"
  port = 80
  default_action {
    type= "forward"
    target_group_arn = aws_lb_target_group.nlb-tg.id
  }  
}

resource "aws_lb_target_group" "nlb-tg" {
  name = "NLB-TG"
  port = var.webserver-port
  target_type = "ip"
  vpc_id = aws_vpc.main.id
  protocol = "TCP"
  
  tags = {
    Name = "NLB-TG"
  }
}

output "NLBId"{
  value = aws_lb.nlb.id
}

output "NLB_TG_arn"{
  value = aws_lb_target_group.nlb-tg.arn
}