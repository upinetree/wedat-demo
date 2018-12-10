resource "aws_api_gateway_resource" "invitation_answers_show" {
  rest_api_id = "${aws_api_gateway_rest_api.main.id}"
  parent_id   = "${aws_api_gateway_resource.invitation_answers.id}"
  path_part   = "{userId}"
  depends_on  = ["aws_api_gateway_rest_api.main", "aws_api_gateway_resource.invitation_answers"]
}

# OPTIONS /inviation-answers/{userId}
resource "aws_api_gateway_method" "invitation_answers_show_options" {
  rest_api_id   = "${aws_api_gateway_rest_api.main.id}"
  resource_id   = "${aws_api_gateway_resource.invitation_answers_show.id}"
  http_method   = "OPTIONS"
  authorization = "NONE"
  depends_on    = ["aws_api_gateway_resource.invitation_answers_show"]
}

resource "aws_api_gateway_method_response" "invitation_answers_show_options_200" {
  rest_api_id = "${aws_api_gateway_rest_api.main.id}"
  resource_id = "${aws_api_gateway_resource.invitation_answers_show.id}"
  http_method = "${aws_api_gateway_method.invitation_answers_show_options.http_method}"
  status_code = "200"

  response_models {
    "application/json" = "Empty"
  }

  response_parameters {
    "method.response.header.Access-Control-Allow-Headers" = true
    "method.response.header.Access-Control-Allow-Methods" = true
    "method.response.header.Access-Control-Allow-Origin"  = true
  }

  depends_on = ["aws_api_gateway_method.invitation_answers_show_options"]
}

resource "aws_api_gateway_integration" "invitation_answers_show_options_integration" {
  rest_api_id = "${aws_api_gateway_rest_api.main.id}"
  resource_id = "${aws_api_gateway_resource.invitation_answers_show.id}"
  http_method = "${aws_api_gateway_method.invitation_answers_show_options.http_method}"
  type        = "MOCK"

  request_templates {
    "application/json" = <<EOF
{"statusCode": 200}
EOF
  }

  depends_on = ["aws_api_gateway_method.invitation_answers_show_options"]
}

resource "aws_api_gateway_integration_response" "invitation_answers_show_options_integration_response" {
  rest_api_id = "${aws_api_gateway_rest_api.main.id}"
  resource_id = "${aws_api_gateway_resource.invitation_answers_show.id}"
  http_method = "${aws_api_gateway_method.invitation_answers_show_options.http_method}"
  status_code = "${aws_api_gateway_method_response.invitation_answers_show_options_200.status_code}"

  response_parameters {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,Authorization,X-Amz-Date,X-Api-Key,X-Amz-Security-Token'"
    "method.response.header.Access-Control-Allow-Methods" = "'DELETE,GET,HEAD,OPTIONS,PATCH,POST,PUT'"
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
  }

  depends_on = ["aws_api_gateway_method_response.invitation_answers_show_options_200"]
}

# GET /invitation-answers/{userId}
resource "aws_api_gateway_method" "invitation_answers_show" {
  rest_api_id   = "${aws_api_gateway_rest_api.main.id}"
  resource_id   = "${aws_api_gateway_resource.invitation_answers_show.id}"
  http_method   = "GET"
  authorization = "NONE"

  request_parameters {
    "method.request.path.userId" = true
  }

  depends_on = ["aws_api_gateway_resource.invitation_answers_show"]
}

resource "aws_api_gateway_method_response" "invitation_answers_show_200" {
  rest_api_id = "${aws_api_gateway_rest_api.main.id}"
  resource_id = "${aws_api_gateway_resource.invitation_answers_show.id}"
  http_method = "${aws_api_gateway_method.invitation_answers_show.http_method}"
  status_code = "200"

  response_models {
    "application/json" = "Empty"
  }

  response_parameters {
    "method.response.header.Access-Control-Allow-Origin" = true
  }

  depends_on = ["aws_api_gateway_method.invitation_answers_show"]
}

resource "aws_api_gateway_integration" "invitation_answers_show_integration" {
  rest_api_id             = "${aws_api_gateway_rest_api.main.id}"
  resource_id             = "${aws_api_gateway_resource.invitation_answers_show.id}"
  http_method             = "${aws_api_gateway_method.invitation_answers_show.http_method}"
  type                    = "AWS"
  uri                     = "arn:aws:apigateway:ap-northeast-1:dynamodb:action/GetItem"
  integration_http_method = "POST"
  credentials             = "${aws_iam_role.dynamodb_full.arn}"
  passthrough_behavior    = "WHEN_NO_TEMPLATES"

  request_parameters {
    "integration.request.path.userId" = "method.request.path.userId"
  }

  request_templates {
    "application/json" = <<EOF
{
  "TableName": "${aws_dynamodb_table.invitation_answers.id}",
  "Key": {
    "userId": {
      "S": "$input.params('userId')"
    }
  }
}
EOF
  }

  depends_on = ["aws_api_gateway_method.invitation_answers_show"]
}

resource "aws_api_gateway_integration_response" "invitation_answers_show_integration_response" {
  rest_api_id = "${aws_api_gateway_rest_api.main.id}"
  resource_id = "${aws_api_gateway_resource.invitation_answers_show.id}"
  http_method = "${aws_api_gateway_method.invitation_answers_show.http_method}"
  status_code = "${aws_api_gateway_method_response.invitation_answers_show_200.status_code}"

  response_parameters {
    "method.response.header.Access-Control-Allow-Origin" = "'*'"
  }

  response_templates = {
    "application/json" = <<EOF
#set($item = $input.path('$.Item'))
{
    #if ($item.size() > 0)
    "userId": "$item.userId.S",
    "firstName": "$item.firstName.S",
    "lastName": "$item.lastName.S",
    "attendance": "$item.attendance.S",
    "message": "$item.message.S",
    "note": "$item.note.S"
    #end
}
EOF
  }

  depends_on = ["aws_api_gateway_method.invitation_answers_show"]
}
