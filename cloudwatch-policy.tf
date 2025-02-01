resource "aws_iam_policy_attachment" "apigateway_logging_attach" {
  name       = "APIGatewayLoggingAttachment"
  roles      = var.labRole
  policy_arn = var.policyArn
}

resource "aws_api_gateway_account" "apigateway_logging" {
  cloudwatch_role_arn = var.labRole
}