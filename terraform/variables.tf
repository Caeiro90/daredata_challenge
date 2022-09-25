variable "aws_region" {
    default = "eu-west-1"
}

variable "kinesis_firehose_stream_name" {
    type = string
    default = "terraform-kinesis-firehose-dd-stream"
}

variable "s3_bucket_name" { 
    type = string 
    default = "dd-bucket-fdpc-20220925"
}

