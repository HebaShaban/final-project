resource "aws_ecr_repository" "sprints-ecr" {
  name = "sprints-ecr"
}
resource "aws_iam_role" "eks-cluster-role" {
  name = "eks-cluster-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      }
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "eks_policy" {
  role       = aws_iam_role.eks-cluster-role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

resource "aws_eks_cluster" "eks-cluster" {
  name     = "eks-cluster"
  role_arn = aws_iam_role.eks-cluster-role.arn
  version  = "1.27"

  vpc_config {
    subnet_ids = [aws_subnet.tf_subnet1.id,aws_subnet.tf_subnet2.id]
  }
}
resource "aws_eks_node_group" "eks-group" {
  cluster_name    = aws_eks_cluster.eks-cluster.name
  node_group_name = "my-eks-group"
  node_role_arn   = aws_iam_role.eks-node-role.arn
  subnet_ids      = [aws_subnet.tf_subnet1.id, aws_subnet.tf_subnet2.id]  

  scaling_config {
    desired_size = 2
    min_size     = 1
    max_size     = 2
  }
}

resource "aws_iam_role" "eks-node-role" {
  name = "my-eks-node-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}
resource "aws_iam_role_policy_attachment" "AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks-node-role.name
}

resource "aws_iam_role_policy_attachment" "AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks-node-role.name
}

resource "aws_iam_role_policy_attachment" "AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks-node-role.name
}
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}
resource "aws_instance" "my-instance1" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "t2.large"
  subnet_id                   = aws_subnet.tf_subnet1.id
  vpc_security_group_ids      = [aws_security_group.tf_securityGroup.id]
  associate_public_ip_address = true
  source_dest_check           = false
  key_pair_name               = "aws"
  tags = {
    Name = "my-instance1"
  }
}
