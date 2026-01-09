resource "aws_iam_instance_profile" "node_profile" {
  name = "eks-node-profile"
  role = aws_iam_role.node_role.name
}