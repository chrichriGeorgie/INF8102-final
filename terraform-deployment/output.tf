output "redirection_url" {
   value = aws_lambda_function_url.redirector_url.function_url
}

output "lb_url" {
   value = aws_lb.c2_lb.dns_name
}