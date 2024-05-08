terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"

   backend "s3" {
    bucket = "tf-backend-bucket-dinesh"
    key    = "backend/terrafrom.tfstate"
    region = "ap-south-1"
    dynamodb_table = "terraform-state-locker"
    encrypt = true
  }
}

provider "aws" {
  region  = "ap-south-1"
}

resource "aws_s3_bucket" "tf-backend-bucket" {
  bucket = "tf-backend-bucket-dinesh-new"
  force_destroy = true
}

resource "aws_s3_bucket_versioning" "tf-bucket-versioning" {
  bucket = aws_s3_bucket.tf-backend-bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_dynamodb_table" "terraform_locks" {
  name = "terraform-state-locker"
  billing_mode = "PAY_PER_REQUEST"
  hash_key = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
}