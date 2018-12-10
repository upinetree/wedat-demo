resource "aws_api_gateway_resource" "invitation_answers" {
  rest_api_id = "${aws_api_gateway_rest_api.main.id}"
  parent_id   = "${aws_api_gateway_rest_api.main.root_resource_id}"
  path_part   = "invitation-answers"
  depends_on  = ["aws_api_gateway_rest_api.main"]
}

# OPTIONS /inviation-answers
resource "aws_api_gateway_method" "invitation_answers_options" {
  rest_api_id   = "${aws_api_gateway_rest_api.main.id}"
  resource_id   = "${aws_api_gateway_resource.invitation_answers.id}"
  http_method   = "OPTIONS"
  authorization = "NONE"
  depends_on    = ["aws_api_gateway_resource.invitation_answers"]
}

resource "aws_api_gateway_method_response" "invitation_answers_options_200" {
  rest_api_id = "${aws_api_gateway_rest_api.main.id}"
  resource_id = "${aws_api_gateway_resource.invitation_answers.id}"
  http_method = "${aws_api_gateway_method.invitation_answers_options.http_method}"
  status_code = "200"

  response_models {
    "application/json" = "Empty"
  }

  response_parameters {
    "method.response.header.Access-Control-Allow-Headers" = true
    "method.response.header.Access-Control-Allow-Methods" = true
    "method.response.header.Access-Control-Allow-Origin"  = true
  }

  depends_on = ["aws_api_gateway_method.invitation_answers_options"]
}

resource "aws_api_gateway_integration" "invitation_answers_options_integration" {
  rest_api_id = "${aws_api_gateway_rest_api.main.id}"
  resource_id = "${aws_api_gateway_resource.invitation_answers.id}"
  http_method = "${aws_api_gateway_method.invitation_answers_options.http_method}"
  type        = "MOCK"

  request_templates {
    "application/json" = <<EOF
{"statusCode": 200}
EOF
  }

  depends_on = ["aws_api_gateway_method.invitation_answers_options"]
}

resource "aws_api_gateway_integration_response" "invitation_answers_options_integration_response" {
  rest_api_id = "${aws_api_gateway_rest_api.main.id}"
  resource_id = "${aws_api_gateway_resource.invitation_answers.id}"
  http_method = "${aws_api_gateway_method.invitation_answers_options.http_method}"
  status_code = "${aws_api_gateway_method_response.invitation_answers_options_200.status_code}"

  response_parameters {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,Authorization,X-Amz-Date,X-Api-Key,X-Amz-Security-Token'"
    "method.response.header.Access-Control-Allow-Methods" = "'DELETE,GET,HEAD,OPTIONS,PATCH,POST,PUT'"
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
  }

  depends_on = ["aws_api_gateway_method_response.invitation_answers_options_200"]
}

# POST /invitation-answers
resource "aws_api_gateway_method" "invitation_answers_post" {
  rest_api_id   = "${aws_api_gateway_rest_api.main.id}"
  resource_id   = "${aws_api_gateway_resource.invitation_answers.id}"
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_method_response" "invitation_answers_post_200" {
  rest_api_id = "${aws_api_gateway_rest_api.main.id}"
  resource_id = "${aws_api_gateway_resource.invitation_answers.id}"
  http_method = "${aws_api_gateway_method.invitation_answers_post.http_method}"
  status_code = "200"

  response_models {
    "application/json" = "Empty"
  }

  response_parameters {
    "method.response.header.Access-Control-Allow-Origin" = true
  }

  depends_on = ["aws_api_gateway_method.invitation_answers_post"]
}

resource "aws_api_gateway_method_response" "invitation_answers_post_400" {
  rest_api_id = "${aws_api_gateway_rest_api.main.id}"
  resource_id = "${aws_api_gateway_resource.invitation_answers.id}"
  http_method = "${aws_api_gateway_method.invitation_answers_post.http_method}"
  status_code = "400"

  response_parameters {
    "method.response.header.Access-Control-Allow-Origin" = true
  }

  depends_on = ["aws_api_gateway_method.invitation_answers_post"]
}

resource "aws_api_gateway_method_response" "invitation_answers_post_500" {
  rest_api_id = "${aws_api_gateway_rest_api.main.id}"
  resource_id = "${aws_api_gateway_resource.invitation_answers.id}"
  http_method = "${aws_api_gateway_method.invitation_answers_post.http_method}"
  status_code = "500"

  response_parameters {
    "method.response.header.Access-Control-Allow-Origin" = true
  }

  depends_on = ["aws_api_gateway_method.invitation_answers_post"]
}

resource "aws_api_gateway_integration" "invitation_answers_post_integration" {
  rest_api_id             = "${aws_api_gateway_rest_api.main.id}"
  resource_id             = "${aws_api_gateway_resource.invitation_answers.id}"
  http_method             = "${aws_api_gateway_method.invitation_answers_post.http_method}"
  integration_http_method = "POST"
  type                    = "AWS"
  uri                     = "arn:aws:apigateway:ap-northeast-1:dynamodb:action/PutItem"
  credentials             = "${aws_iam_role.dynamodb_full.arn}"
  passthrough_behavior    = "WHEN_NO_TEMPLATES"

  request_templates {
    "application/json" = <<EOF
#set($inputRoot = $input.path('$'))
{
    "TableName": "${aws_dynamodb_table.invitation_answers.id}",
    "Item": {
        "userId": {"S": "$inputRoot.userId"},
        "attendance": {"BOOL": "$inputRoot.attendance"},
        "firstName": {"S": "$inputRoot.firstName"},
        "lastName": {"S": "$inputRoot.lastName"},
        "createdAt": {"S": "$inputRoot.createdAt"}
        #if ($inputRoot.additionalAttendees.size() > 0)
            ,"additionalAttendees": {"SS": [
            #foreach($attendee in $inputRoot.additionalAttendees)
                "$attendee"#if($foreach.hasNext),#end
            #end
          ]}
        #end
        #if ($inputRoot.message && $inputRoot.message != "")
            ,"message": {"S": "$inputRoot.message"}
        #end
        #if ($inputRoot.note && $inputRoot.note != "")
            ,"note": {"S": "$inputRoot.note"}
        #end
    }
}
EOF
  }

  depends_on = ["aws_api_gateway_method.invitation_answers_post", "aws_iam_role.dynamodb_full"]
}

resource "aws_api_gateway_integration_response" "invitation_answers_post_2xx" {
  rest_api_id = "${aws_api_gateway_rest_api.main.id}"
  resource_id = "${aws_api_gateway_resource.invitation_answers.id}"
  http_method = "${aws_api_gateway_method.invitation_answers_post.http_method}"
  status_code = "${aws_api_gateway_method_response.invitation_answers_post_200.status_code}"

  response_parameters {
    "method.response.header.Access-Control-Allow-Origin" = "'*'"
  }

  response_templates {
    "application/json" = "{'message':'Success'}"
  }

  depends_on = ["aws_api_gateway_integration.invitation_answers_post_integration"]
}

resource "aws_api_gateway_integration_response" "invitation_answers_post_4xx" {
  rest_api_id       = "${aws_api_gateway_rest_api.main.id}"
  resource_id       = "${aws_api_gateway_resource.invitation_answers.id}"
  http_method       = "${aws_api_gateway_method.invitation_answers_post.http_method}"
  status_code       = "${aws_api_gateway_method_response.invitation_answers_post_400.status_code}"
  selection_pattern = "4\\d{2}"

  response_parameters {
    "method.response.header.Access-Control-Allow-Origin" = "'*'"
  }

  depends_on = ["aws_api_gateway_integration.invitation_answers_post_integration"]
}

resource "aws_api_gateway_integration_response" "invitation_answers_post_5xx" {
  rest_api_id       = "${aws_api_gateway_rest_api.main.id}"
  resource_id       = "${aws_api_gateway_resource.invitation_answers.id}"
  http_method       = "${aws_api_gateway_method.invitation_answers_post.http_method}"
  status_code       = "${aws_api_gateway_method_response.invitation_answers_post_500.status_code}"
  selection_pattern = "5\\d{2}"

  response_parameters {
    "method.response.header.Access-Control-Allow-Origin" = "'*'"
  }

  depends_on = ["aws_api_gateway_integration.invitation_answers_post_integration"]
}
