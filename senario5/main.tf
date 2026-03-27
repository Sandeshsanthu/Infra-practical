resource "aws_iam_user" "lb" {
  count = length(var.var_name)
  name = var.var_name[count.index]
  path = "/system/"
  tags = {
    tag-key = "tag-value"


  }
}
resource "aws_iam_access_key" "lb"{
     count = length(var.var_name)
     user = var.var_name[count.index]
     depends_on = [aws_iam_user.lb]

}

data "aws_iam_policy_document" "lb_ro"{
  statement {
    effect = "Allow"
    actions = ["ec2:Describe*"]
    resources = ["*"]

  }
}
resource "aws_iam_user_policy" "lb_ro"{
  name = "test"
  count = length(var.var_name)
  user = var.var_name[count.index]
  policy = data.aws_iam_policy_document.lb_ro.json
  depends_on = [aws_iam_user.lb]
}
