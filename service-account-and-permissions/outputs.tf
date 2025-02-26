//var.function_service_account

output "service_account_email" {
  value=google_service_account.function-executor.email
}