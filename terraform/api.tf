resource "aws_api_gateway_rest_api" "main" {
  name        = "wedat"
  description = "WedA&T Production"
}

resource "aws_api_gateway_deployment" "prod" {
  depends_on = [
    "aws_api_gateway_method.invitation_answers_post",
    "aws_api_gateway_method.invitation_answers_show",
  ]

  rest_api_id = "${aws_api_gateway_rest_api.main.id}"
  stage_name  = "prod"
}
