module "lambda_function" {
  source = "terraform-aws-modules/lambda/aws"

  function_name = "email-service-function"
  description   = "A function to trigger email confirmations and sign-up notifications"
  handler       = "index.lambda_handler"
  runtime       = "nodejs18.x"

  source_path = "./emailLambda.js"
  attach_policy_json = true
  policy_json = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ses:SendEmail",
                "ses:SendRawEmail"
            ],
            "Resource": "*"
        }
    ]
})
  
  tags = {
    Name = "email-service-function"
  }
}