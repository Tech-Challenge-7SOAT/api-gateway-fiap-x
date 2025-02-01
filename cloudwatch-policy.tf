resource "aws_iam_role" "apigateway_logging_role" {
  name = "APIGatewayCloudWatchRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "apigateway.amazonaws.com"
      }
    }]
  })
}
resource "aws_iam_policy_attachment" "apigateway_logging_attach" {
  name       = "APIGatewayLoggingAttachment"
  roles      = [aws_iam_role.apigateway_logging_role.name]
  policy_arn = var.policyArn
}

resource "aws_api_gateway_account" "apigateway_logging" {
  cloudwatch_role_arn = aws_iam_role.apigateway_logging_role.arn
}