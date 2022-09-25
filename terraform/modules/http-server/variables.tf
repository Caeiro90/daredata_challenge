variable "vpc_cidr_block"  {
    description = "CIDR block for VPC"
    type = string
    default = "10.0.0.0/16"
}

variable subnet_count {
    description = "Number of subnets"
    type = map(number)
    default = {
      public = 1
    }
}

variable "public_subnet_cidr_blocks" {
    description = "Available CIDR blocks for public subnets"
    type = list(string)
    default = [ 
        "10.0.1.0/24",
        "10.0.2.0/24",
        "10.0.3.0/24",
        "10.0.4.0/24" 
    ]
}

variable "my_ip" {
    description = "Your IP address"
    type = string
    sensitive = true
    default = "148.63.51.157"
}

variable "settings" {
    description = "Configuration settings"
    type = map(any)
    default = {
      "web_app" = {
        count           = 1          
        instance_type   = "t2.micro" 
      }
    }
}