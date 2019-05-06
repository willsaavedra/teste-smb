provider "aws" {
  access_key = "${var.AWS_ACCESS_KEY_ID}"
  secret_key = "${var.AWS_SECRET_ACCESS_KEY}"
  region     = "${var.AWS_REGION}"
}

# VPV CREATE

resource "aws_vpc" "vpc_smartbank" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags {
    Name = "${var.name}"
    Ambiente = "teste-pratico"
  }
}

# SUBNET PUB CREATE

resource "aws_subnet" "sub_smartbank_pub" {
  vpc_id     = "${aws_vpc.vpc_smartbank.id}"
  cidr_block = "10.0.1.0/24"

  tags {
    Name = "${var.name}-pub"
    Ambiente = "teste-pratico"
  }
}

# SUBNET PRIV CREATE
resource "aws_subnet" "sub_smartbank_priv" {
  vpc_id     = "${aws_vpc.vpc_smartbank.id}"
  cidr_block = "10.0.4.0/24"

  tags {
    Name = "${var.name}-priv"
    Ambiente = "teste-pratico"
  }
}

# SUBNET CREATE DB

resource "aws_subnet" "sub_smartbank_db_1" {
  vpc_id     = "${aws_vpc.vpc_smartbank.id}"
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-east-1b"

  tags {
    Name = "${var.name}-db1"
    Ambiente = "teste-pratico"
  }
}

# SUBNET CREATE DB 2

resource "aws_subnet" "sub_smartbank_db_2" {
  vpc_id     = "${aws_vpc.vpc_smartbank.id}"
  cidr_block = "10.0.3.0/24"
  availability_zone = "us-east-1a"

  tags {
    Name = "${var.name}-db2"
    Ambiente = "teste-pratico"
  }
}

# security_groups CREATE

resource "aws_default_security_group" "sg_smartbank_app" {
  vpc_id     = "${aws_vpc.vpc_smartbank.id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["177.62.187.124/32"]
  }

    ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

    egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "${var.name}"
    Ambiente = "teste-pratico"
  }

}

# INTERNET_GATEWAY CREATE

resource "aws_internet_gateway" "gw_cloud4erp_dc" {
  vpc_id = "${aws_vpc.vpc_smartbank.id}"

  tags {
    Name = "${var.name}"
    Ambiente = "teste-pratico"
  }
}

# ROUTE TABLE CREATE 

resource "aws_default_route_table" "rt_smartbank" {
  default_route_table_id = "${aws_vpc.vpc_smartbank.default_route_table_id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.gw_cloud4erp_dc.id}"
  }

}

# ROUTE TABLE CREATE DB

resource "aws_route_table" "rt_smartbank_db" {
  vpc_id = "${aws_vpc.vpc_smartbank.id}"
}

# ROUTE TABLE ASSOCIATION CREATE

resource "aws_route_table_association" "rts_cloud4erp_dc" {
  subnet_id      = "${aws_subnet.sub_smartbank_pub.id}"
  route_table_id = "${aws_default_route_table.rt_smartbank.id}"
}

resource "aws_route_table_association" "rts_cloud4erp_dc_db" {
  subnet_id      = "${aws_subnet.sub_smartbank_db_1.id}"
  route_table_id = "${aws_route_table.rt_smartbank_db.id}"
}

resource "aws_route_table_association" "rts_cloud4erp_dc_db_2" {
  subnet_id      = "${aws_subnet.sub_smartbank_db_2.id}"
  route_table_id = "${aws_route_table.rt_smartbank_db.id}"
}

# ELASTIC IP CREATE AND ASSOCIATION

resource "aws_eip" "lb_ip_teste" {
  instance = "${aws_instance.ec2_app_web.id}"
  vpc      = true
}

data "template_file" "user_data" {
  template = "${file("./userdata.tpl")}"
}


# EC2 CREATE

resource "aws_instance" "ec2_app_web" {
  ami           = "ami-0a313d6098716f372"
  instance_type = "${var.class_instance}"
  subnet_id     = "${aws_subnet.sub_smartbank_pub.id}"
  key_name      = "smartbank"
  security_groups = ["${aws_default_security_group.sg_smartbank_app.id}"]
  user_data     = "${data.template_file.user_data.rendered}"

  tags {
    Name = "${var.name}"
    Ambiente = "teste-pratico"
  }

}

resource "aws_ebs_volume" "ebs_ec2_app_web" {
  availability_zone = "${aws_instance.ec2_app_web.availability_zone}"
  size              = "${var.size_volume}"
  type              = "gp2"

  tags {
    Name = "${var.name}-D"
    Ambiente = "teste-pratico"
  }

}

resource "aws_volume_attachment" "ebs_att_web_app" {
  device_name = "/dev/sdh"
  volume_id   = "${aws_ebs_volume.ebs_ec2_app_web.id}"
  instance_id = "${aws_instance.ec2_app_web.id}"
}

# create rds

resource "aws_db_instance" "rds_cloud4erp_dc" {
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "postgres"
  engine_version       = "11.2"
  instance_class       = "db.m4.large"
  username             = "${var.name}"
  password             = "${var.name}"    
  db_subnet_group_name = "${aws_db_subnet_group.gp_dc_sub.id}"
  vpc_security_group_ids = ["${aws_default_security_group.sg_smartbank_app.id}"]
  skip_final_snapshot  = "true"
  
}

resource "aws_db_subnet_group" "gp_dc_sub" {
  name       = "gp-sub-${var.name}"
  subnet_ids = ["${aws_subnet.sub_smartbank_db_1.id}","${aws_subnet.sub_smartbank_db_2.id}"]
}