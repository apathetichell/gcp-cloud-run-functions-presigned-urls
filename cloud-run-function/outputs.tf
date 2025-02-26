

output "function_uri" {
  value=google_cloudfunctions2_function.presigned_url_get.service_config[0].uri
}
