terraform {
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "4.0.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

module "s3bucket" {
  source = "./modules/s3bucket"
  s3_bucket_name = var.s3_bucket_name
}

module "kinesis-setup" {
  source = "./modules/kinesis-setup"
  bucket_arn = module.s3bucket.arn
  kinesis_firehose_stream_name = var.kinesis_firehose_stream_name
}

module "http-server" {
  source = "./modules/http-server"
}