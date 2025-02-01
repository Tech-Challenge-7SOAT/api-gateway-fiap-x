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
      Action = "sts:AssumeRole"
    }]
  })
}
resource "aws_iam_role_policy_attachment" "apigateway_logging_attach" {
  role       = aws_iam_role.apigateway_logging_role.name
  policy_arn = var.policyArn
}

resource "aws_api_gateway_account" "apigateway_logging" {
  cloudwatch_role_arn = aws_iam_role.apigateway_logging_role.arn
  depends_on          = [aws_iam_role_policy_attachment.apigateway_logging_attach]
}