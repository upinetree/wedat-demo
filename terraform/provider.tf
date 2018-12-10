provider "aws" {
  profile = "wedat"
  region  = "ap-northeast-1"
}

provider "aws" {
  alias   = "us-east-1"
  profile = "wedat"
  region  = "us-east-1"
}
