resource "aws_cognito_user_pool" "fiapx_pool" {
  name = "fiapx-pool"
}

resource "aws_cognito_user_pool_client" "fiapx_client" {
  name = "fiapx-client"
  user_pool_id = aws_cognito_user_pool.fiapx_pool.id
  generate_secret = false
  explicit_auth_flows = ["ALLOW_USER_PASSWORD_AUTH", "ALLOW_REFRESH_TOKEN_AUTH"]
}

resource "aws_cognito_user_pool_domain" "my_domain" {
  domain = "fiapx-auth-${random_string.suffix.result}"
  user_pool_id = aws_cognito_user_pool.fiapx_pool.id
}

resource "random_string" "suffix" {
  length  = 6
  special = false
  upper   = false
}