# Criar um API Gateway REST
resource "aws_api_gateway_rest_api" "fiapx_api" {
  name        = "fiapx-api"
  description = "API Gateway protegido pelo Cognito"
}

# Criar um Authorizer no API Gateway para usar o Cognito
resource "aws_api_gateway_authorizer" "cognito_auth" {
  name          = "cognito-authorizer"
  rest_api_id   = aws_api_gateway_rest_api.fiapx_api.id
  type          = "COGNITO_USER_POOLS"
  provider_arns = [aws_cognito_user_pool.fiapx_pool.arn]
}

resource "aws_api_gateway_deployment" "fiapx_api" {
  rest_api_id = aws_api_gateway_rest_api.fiapx_api.id
  stage_name  = "prod"
}
