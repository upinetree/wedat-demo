locals {
  domain       = "wedat.info"
  s3_origin_id = "S3-assets.wedat.info"
}

resource "aws_s3_bucket" "assets" {
  bucket = "assets.wedat.info"
  acl    = "private"

  website {
    index_document = "index.html"
    error_document = "index.html"
  }
}

resource "aws_dynamodb_table" "invitation_answers" {
  name           = "WedatInvitationAnswers"
  read_capacity  = 5
  write_capacity = 5
  hash_key       = "userId"

  attribute {
    name = "userId"
    type = "S"
  }
}

resource "aws_iam_role" "dynamodb_full" {
  name = "APIGateway_ProxyDynamoDBFull"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "apigateway.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "dynamodb_full" {
  role       = "${aws_iam_role.dynamodb_full.name}"
  policy_arn = "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess"
}
