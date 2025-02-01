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

resource "aws_api_gateway_resource" "proxy" {
  rest_api_id = aws_api_gateway_rest_api.fiapx_api.id
  parent_id   = aws_api_gateway_rest_api.fiapx_api.root_resource_id
  path_part   = "proxy"
}

resource "aws_api_gateway_method" "proxy" {
  rest_api_id   = aws_api_gateway_rest_api.fiapx_api.id
  resource_id   = aws_api_gateway_resource.proxy.id
  http_method   = "ANY"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.cognito_auth.id
}

resource "aws_api_gateway_integration" "proxy" {
  rest_api_id = aws_api_gateway_rest_api.fiapx_api.id
  resource_id = aws_api_gateway_resource.proxy.id
  http_method = aws_api_gateway_method.proxy.http_method
  type        = "HTTP_PROXY"
  integration_http_method = "ANY"
  uri         = aws_lb.my_alb.dns_name
}

resource "aws_api_gateway_deployment" "fiapx_api" {
  depends_on  = [aws_api_gateway_integration.proxy]
  rest_api_id = aws_api_gateway_rest_api.fiapx_api.id
  stage_name  = "prod"
}
