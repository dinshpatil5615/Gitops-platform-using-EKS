resource "aws_iam_role" "node_role" {
  name = "eks-node-role"

  assume_role_policy = jsonencode ({
    Version = "2012-10-17"
    Statement= [{
        Effect= "Allow"
        Principal = {
        Service = "ec2.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "worker_policy" {
  role = aws_iam_role.node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy" 
}

resource "aws_iam_role_policy_attachment" "node_cni_policy" {
  role       = aws_iam_role.node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

resource "aws_iam_role_policy_attachment" "node_ecr_policy" {
  role       = aws_iam_role.node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

# resource "aws_eks_node_group" "nodes" {
#   cluster_name = aws_eks_cluster.eks.name
#   node_group_name = "platform-nodes"
#   node_role_arn = aws_iam_role.node_role.arn
#   subnet_ids = [
#     aws_subnet.public_subnet.id
#   ]

#   scaling_config {
#     desired_size = 2
#     min_size = 1
#     max_size = 3
#   }
#   instance_types = ["t3.medium"]

#     depends_on = [
#     aws_iam_role_policy_attachment.worker_policy,
#     aws_iam_role_policy_attachment.node_cni_policy,
#     aws_iam_role_policy_attachment.node_ecr_policy
#   ]
# }

resource "aws_eks_node_group" "managed_nodes" {
  cluster_name    = aws_eks_cluster.eks.name
  node_group_name = "managed-nodes"
  node_role_arn  = aws_iam_role.node_role.arn
  subnet_ids     = [aws_subnet.public_subnet.id]

  instance_types = ["t3.small"]

  scaling_config {
    desired_size = 1
    min_size     = 1
    max_size     = 2
  }

  depends_on = [
    aws_iam_role_policy_attachment.worker_policy,
    aws_iam_role_policy_attachment.node_cni_policy,
    aws_iam_role_policy_attachment.node_ecr_policy
  ]
}