output "user pool id" {
  value = "${aws_cognito_user_pool.main.id}"
}

output "user pool app client id" {
  value = "${aws_cognito_user_pool_client.web.id}"
}

output "identity pool id" {
  value = "${aws_cognito_identity_pool.main.id}"
}

output "api invoke url" {
  value = "${aws_api_gateway_deployment.prod.invoke_url}"
}
