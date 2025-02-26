
data "archive_file" "default" {
  type        = "zip"
  output_path = "/tmp/function-source-${var.random_file_number}.zip"
  source_dir  = "./presigned-url-get"
}


resource "google_storage_bucket" "function_storage_bucket"{
    name=var.function-bucket
    location=var.project_location
}




resource "google_storage_bucket_object" "object" {
  name   = "function-source.zip-${var.random_file_number}"
  bucket = google_storage_bucket.function_storage_bucket.name
  source = data.archive_file.default.output_path #Add path to the zipped function source code
}

resource "google_cloudfunctions2_function" "presigned_url_get" {
  name        = var.function-name
  location    = var.project_location
  description = "function to create presigned urls for GCS objects"

  build_config {
    runtime     = "python311"
    entry_point = "sign_GCS_object" # Set the entry point
    source {
      storage_source {
        bucket = google_storage_bucket.function_storage_bucket.name
        object = google_storage_bucket_object.object.name
      }
    }
   }

  service_config {
    max_instance_count = 1
    available_memory   = "256M"
    timeout_seconds    = 60
    environment_variables = {
        ## note - this bucket is NOT created by this process. The assumption is that this bucket already exists. see note in main.
            bucket= var.presigned-url-bucket
    }

    service_account_email = var.function-service-account-email 
  
    }
}


## this allows for unauthenticated access
resource "google_cloud_run_service_iam_member" "member" {
  location = google_cloudfunctions2_function.presigned_url_get.location
  service  = google_cloudfunctions2_function.presigned_url_get.name
  role     = "roles/run.invoker"
  member   = "allUsers"
}