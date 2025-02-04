resource "aws_api_gateway_vpc_link" "fiapx_vpc_link" {
  name        = "fiapx-vpc-link"
  target_arns = [aws_lb.my_alb.arn]

  lifecycle {
    create_before_destroy = true
  }
}