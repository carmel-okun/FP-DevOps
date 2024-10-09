# Application Load Balancer
# resource "aws_lb" "app_lb" {
#   name               = "yoram-carmel-app-lb"
#   internal           = false
#   load_balancer_type = "application"
#   security_groups    = [aws_security_group.lb_sg.id]
#   subnets            = [aws_subnet.public_a.id, aws_subnet.public_b.id]
# }

# resource "aws_waf_web_acl" "waf" {
#   name        = "yoram-carmel-waf"
#   metric_name = "YoramCarmelWafMetric"
#   default_action {
#     type = "ALLOW"
#   }
# }
