# Data Engineering Challenge

For this challenge, i was only able to setup the requested infrastructure via terraform.

I manually created an IAM user in my AWS account via the management console with the following permissions:

- AmazonEC2FullAccess
- AmazonRDSFullAccess
- AmazonKinesisFirehoseFullAccess
- IAMFullAccess
- AmazonS3FullAccess

The respective AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY from that user was also added as environment variables in my local machine.

`$env:AWS_ACCESS_KEY_ID="xxxxxxx"`
`$env:AWS_SECRET_ACCESS_KEY="xxxxxxx"`

Also created an ssh key by running the following command in the terraform directory:

`ssh-keygen -t rsa -b 4096 -m pem -f dd_kp && openssl rsa -in dd_kp.pem -outform pem && chmod 400 dd_kp.pem` 

Having done that, to set up the infrstructure at once i ran the following commands:

`terraform init`

`terraform apply`





