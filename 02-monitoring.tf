
data "aws_region" "this" {}

data "aws_caller_identity" "this" {}

data "aws_eks_cluster" "this" {
  name = var.cluster-name
}

data "aws_iam_openid_connect_provider" "this" {
  url = data.aws_eks_cluster.this.identity[0].oidc[0].issuer
}

locals {
  oidc_provider     = try(replace(data.aws_eks_cluster.this.identity[0].oidc[0].issuer, "https://", ""), null)
  oidc_provider_arn = data.aws_iam_openid_connect_provider.this.arn
}

data "aws_iam_policy_document" "assume_role_service_account" {
  count = var.enable-alerting && var.create-cloudwatch-exporter
  statement {
    effect = "Allow"

    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [local.oidc_provider_arn]
    }

    condition {
      test     = "StringEquals"
      variable = "${local.oidc_provider}:sub"
      values   = ["system:serviceaccount:${var.cloudwatch-exporter-namespace}:prometheus-cloudwatch-exporter"]
    }

    condition {
      test     = "StringEquals"
      variable = "${local.oidc_provider}:aud"
      values   = ["sts.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "irsa" {
  count = var.enable-alerting && var.create-cloudwatch-exporter
  name_prefix = "cassandra"
  assume_role_policy = data.aws_iam_policy_document.assume_role_service_account[0].json

  tags = {
    Terraform   = "True"
    Environment = var.environment
    Deploy_Name = "prometheus-cloudwatch-exporter"
    Namespace   = var.cloudwatch-exporter-namespace
  }
}

resource "helm_release" "cloudwatch-exporter" {
  count = var.enable-alerting && var.create-cloudwatch-exporter
  repository = "https://prometheus-community.github.io/helm-charts"
  name = "prometheus-cloudwatch-exporter"
  chart = "prometheus-community/prometheus-cloudwatch-exporter"
  namespace = var.cloudwatch-exporter-namespace

  create_namespace = true
  recreate_pods = True

  set {
    name = "aws.role"
    value = aws_iam_role.irsa[0].arn
  }

}