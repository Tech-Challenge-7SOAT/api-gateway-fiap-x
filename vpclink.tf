resource "aws_lb" "lb_fiapx" {
  name               = "LB-fiapx"
  internal           = true
  load_balancer_type = "network"

  subnet_mapping {
    subnet_id = data.aws_subnets.default.ids
  }
}

resource "aws_api_gateway_vpc_link" "vpclink_fiapx" {
  name        = "VPCLink-fiapx"
  description = "VPC Link FIAPX"
  target_arns = aws_lb.ecs_alb.arn
}