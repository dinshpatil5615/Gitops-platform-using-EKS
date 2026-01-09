data "aws_ami" "eks_ami" {
  most_recent = true
  owners      = ["602401143452"]

  filter {
    name   = "name"
    values = ["amazon-eks-node-*"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

resource "aws_launch_template" "eks_nodes" {
  name_prefix   = "eks-nodes-"
  image_id      = data.aws_ami.eks_ami.id
  instance_type = "t3.small"   # ✅ FIXED

  vpc_security_group_ids = [
    aws_security_group.eks_node_sg.id
  ]

  iam_instance_profile {
    name = aws_iam_instance_profile.node_profile.name
  }

  user_data = base64encode(<<EOF
#!/bin/bash
/etc/eks/bootstrap.sh ${aws_eks_cluster.eks.name}
EOF
  )
}