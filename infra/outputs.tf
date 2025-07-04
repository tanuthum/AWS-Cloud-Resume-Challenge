output "api_url" {
  value = "${aws_apigatewayv2_api.lambda_api.api_endpoint}/count"
}

output "cloudfront_url" {
  value = "https://${aws_cloudfront_distribution.resume_distribution.domain_name}"
}

