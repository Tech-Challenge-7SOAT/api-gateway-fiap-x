resource "aws_api_gateway_rest_api" "fiapx_api" {
  name        = "fiapx-api"
  description = "API Gateway protegido pelo Cognito"
  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_api_gateway_authorizer" "cognito_auth" {
  name          = "cognito-authorizer"
  rest_api_id   = aws_api_gateway_rest_api.fiapx_api.id
  type          = "COGNITO_USER_POOLS"
  provider_arns = [aws_cognito_user_pool.fiapx_pool.arn]
}

resource "aws_api_gateway_resource" "fiapx_api_resource" {
  rest_api_id = aws_api_gateway_rest_api.fiapx_api.id
  parent_id   = aws_api_gateway_rest_api.fiapx_api.root_resource_id
  path_part   = "videos"
}

resource "aws_api_gateway_method" "api_gateway_method_get" {
  rest_api_id   = aws_api_gateway_rest_api.fiapx_api.id
  resource_id   = aws_api_gateway_resource.fiapx_api_resource.id
  http_method   = "GET"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.cognito_auth.id
}

resource "aws_api_gateway_integration" "http_integration_get" {
  rest_api_id             = aws_api_gateway_rest_api.fiapx_api.id
  resource_id             = aws_api_gateway_resource.fiapx_api_resource.id
  http_method             = aws_api_gateway_method.api_gateway_method_get.http_method
  integration_http_method = "GET"
  type                    = "HTTP"
  uri                     = "https://${aws_lb.ecs_alb.dns_name}"
}

resource "aws_api_gateway_method" "api_gateway_method_post" {
  rest_api_id   = aws_api_gateway_rest_api.fiapx_api.id
  resource_id   = aws_api_gateway_resource.fiapx_api_resource.id
  http_method   = "POST"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.cognito_auth.id
}

resource "aws_api_gateway_integration" "http_integration_post" {
  rest_api_id             = aws_api_gateway_rest_api.fiapx_api.id
  resource_id             = aws_api_gateway_resource.fiapx_api_resource.id
  http_method             = aws_api_gateway_method.api_gateway_method_post.http_method
  integration_http_method = "POST"
  type                    = "HTTP"
  uri                     = "https://${aws_lb.ecs_alb.dns_name}"
}

resource "aws_api_gateway_deployment" "fiapx_api_deployment" {
  depends_on = [
    aws_api_gateway_integration.http_integration_get,
    aws_api_gateway_integration.http_integration_post,
    aws_api_gateway_authorizer.cognito_auth
  ]
  rest_api_id = aws_api_gateway_rest_api.fiapx_api.id
}

resource "aws_api_gateway_stage" "fiapx_api_stage" {
  stage_name    = "prod"
  rest_api_id   = aws_api_gateway_rest_api.fiapx_api.id
  deployment_id = aws_api_gateway_deployment.fiapx_api_deployment.id
}