data "archive_file" "deployment_gate" {
  type        = "zip"
  source_dir  = "${path.module}/../lambda/deployment_gate"
  output_path = "${path.module}/builds/deployment_gate.zip"
}

resource "aws_lambda_function" "deployment_gate" {
  function_name    = "gaterkeeper-deployment-gate"
  filename         = data.archive_file.deployment_gate.output_path
  source_code_hash = data.archive_file.deployment_gate.output_base64sha256
  handler          = "handler.handler"
  runtime          = "python3.12"
  role             = aws_iam_role.deployment_gate.arn
}