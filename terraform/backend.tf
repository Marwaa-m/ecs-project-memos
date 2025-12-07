terraform {
  backend "s3" {
    bucket         = "memos-tf-state-9372jk"
    key            = "memos/terraform.tfstate"
    region         = "eu-west-2"
    encrypt        = true
    dynamodb_table = "memos-tf-locks"
  }
}