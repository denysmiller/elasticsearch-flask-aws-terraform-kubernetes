provider "aws" {  
  region = "us-west-2"  
}  

resource "aws_eks_cluster" "this" {  
  name     = "flask-elasticsearch-cluster"  
  role_arn = aws_iam_role.cluster_role.arn  

  vpc_config {  
    subnet_ids = aws_subnet.public.*.id  
  }  
}  

resource "aws_iam_role" "cluster_role" {  
  name = "eks_cluster_role"  

  assume_role_policy = <<EOF  
{  
  "Version": "2012-10-17",  
  "Statement": [  
    {  
      "Action": "sts:AssumeRole",  
      "Principal": {  
        "Service": "eks.amazonaws.com"  
      },  
      "Effect": "Allow",  
      "Sid": ""  
    }  
  ]  
}  
EOF  
}  

resource "aws_iam_role_policy_attachment" "cluster_policy" {  
  role       = aws_iam_role.cluster_role.name  
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"  
}  

resource "aws_vpc" "main" {  
  cidr_block = "10.0.0.0/16"  
}  

resource "aws_subnet" "public" {  
  count             = 2  
  vpc_id            = aws_vpc.main.id  
  cidr_block        = "10.0.${count.index}.0/24"  
  availability_zone = element(data.aws_availability_zones.available.names, count.index)  

  tags = {  
    Name = "public-subnet-${count.index}"  
  }  
}  

data "aws_availability_zones" "available" {}  
