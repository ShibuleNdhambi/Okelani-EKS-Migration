resource "aws_iam_role" "node_group_role" {
    name = "node_group_role"

    assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Service": "eks.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "node_group_policy_attachment" {
    role       = aws_iam_role.node_group_role.name
    policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess"
}

resource "aws_iam_role_policy_attachment" "ecs_policy_attachment" {
    role       = aws_iam_role.node_group_role.name
    policy_arn = "arn:aws:iam::aws:policy/AmazonECS_FullAccess"
}

resource "aws_iam_role_policy_attachment" "fargate_policy_attachment" {
    role       = aws_iam_role.node_group_role.name
    policy_arn = "arn:aws:iam::aws:policy/AmazonECS_FargateFullAccess"
}

resource "aws_iam_role_policy_attachment" "rds_policy_attachment" {
    role       = aws_iam_role.node_group_role.name
    policy_arn = "arn:aws:iam::aws:policy/AmazonRDSFullAccess"
}

resource "aws_iam_role_policy_attachment" "aurora_policy_attachment" {
    role       = aws_iam_role.node_group_role.name
    policy_arn = "arn:aws:iam::aws:policy/AmazonAuroraFullAccess"
}