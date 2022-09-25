data "aws_availability_zones" "available" {
    state = "available"
}

resource "aws_vpc" "dd_vpc" {
  cidr_block = var.vpc_cidr_block
  enable_dns_hostnames = true

  tags = {
    Name = "dd_vpc"
  }
}

resource "aws_internet_gateway" "dd_igw" {
    vpc_id = aws_vpc.dd_vpc.id

    tags = {
      Name = "dd_igw"
    }
}

resource "aws_subnet" "dd_public_subnet" {
  count = var.subnet_count.public
  vpc_id = aws_vpc.dd_vpc.id
  cidr_block = var.public_subnet_cidr_blocks[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "dd_public_subnet_${count.index}"
  }
}

resource "aws_route_table" "dd_public_rt" {
    vpc_id = aws_vpc.dd_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.dd_igw.id
  }

  route {
    ipv6_cidr_block = "::/0"
    gateway_id      = aws_internet_gateway.dd_igw.id
  }
}

resource "aws_route_table_association" "public" {
    count = var.subnet_count.public
    route_table_id = aws_route_table.dd_public_rt.id
    subnet_id = aws_subnet.dd_public_subnet[count.index].id
}

resource "aws_security_group" "dd_web_sg" {
  name   = "dd_web_sg"
  description = "Security group for dd web servers"
  vpc_id = aws_vpc.dd_vpc.id

  ingress {
    description = "Allow all traffic through HTTP"
    from_port   = "80"
    to_port     = "80"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow all traffic through HTTPS"
    from_port   = "443"
    to_port     = "443"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow SSH from my computer"
    from_port   = "22"
    to_port     = "22"
    protocol    = "tcp"
    cidr_blocks = ["${var.my_ip}/32"]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "dd_web_sg"
  }
}

resource "aws_key_pair" "dd_kp" {
  key_name = "dd_kp"
  public_key = file("dd_kp.pub")
}

data "aws_ami" "ubuntu" {
  most_recent = true

  owners = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "web" {
  count = var.settings.web_app.count
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.settings.web_app.instance_type
  subnet_id = aws_subnet.dd_public_subnet[count.index].id
  key_name = aws_key_pair.dd_kp.key_name
  vpc_security_group_ids = [aws_security_group.dd_web_sg.id]

  tags = {
    Name = "dd-http-server"
  }
}

resource "aws_eip" "dd_web_eip" {
    count = var.settings.web_app.count
    instance = aws_instance.web[count.index].id
    vpc = true

    tags = {
        Name = "dd_web_eip_${count.index}"
    }
}



