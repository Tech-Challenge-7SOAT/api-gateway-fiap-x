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

resource "aws_api_gateway_deployment" "fiapx_api" {
  rest_api_id = aws_api_gateway_rest_api.fiapx_api.id
}

resource "aws_api_gateway_stage" "fiapx_api_stage" {
  stage_name    = "prod"
  rest_api_id   = aws_api_gateway_rest_api.fiapx_api.id
  deployment_id = aws_api_gateway_deployment.fiapx_api.id
}

resource "aws_api_gateway_resource" "fiapx_api_resource" {
  rest_api_id = aws_api_gateway_rest_api.fiapx_api.id
  parent_id   = aws_api_gateway_rest_api.fiapx_api.root_resource_id
  path_part   = "videos"
}

resource "aws_api_gateway_method" "api_gateway_method_get" {
  rest_api_id   = aws_api_gateway_rest_api.fiapx_api.id
  resource_id   = aws_api_gateway_resource.fiapx_api.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_method" "api_gateway_method_post" {
  rest_api_id   = aws_api_gateway_rest_api.fiapx_api.id
  resource_id   = aws_api_gateway_resource.fiapx_api.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_method_settings" "s" {
  rest_api_id = aws_api_gateway_rest_api.fiapx_api.id
  stage_name  = aws_api_gateway_stage.fiapx_api.stage_name
  method_path = "${aws_api_gateway_resource.fiapx_api.path_part}/${aws_api_gateway_method.fiapx_api.http_method}"

  settings {
    metrics_enabled = true
    logging_level   = "INFO"
  }
}