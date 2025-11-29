terraform {
  backend "s3" {
    # Replace the following with your bucket/key/region/table
    bucket         = "your-terraform-state-bucket"
    key            = "memos/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "your-terraform-lock-table"
    encrypt        = true
  }
}