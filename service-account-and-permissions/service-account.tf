

resource "google_service_account" "function-executor" {
    account_id =var.function-service-account
    description="this is the service account which executes the cloud run function"
}

resource "google_project_iam_custom_role" "presigned-url-storage" {
  role_id     = var.presigned-url-storage-object-user
  title       = "presigned url storage role"
  description = "This is the role necessary to allow the cloud run function access to the GCS bucket"
  permissions = ["storage.folders.get","storage.folders.list","storage.multipartUploads.create","storage.multipartUploads.list",
    "storage.objects.create","storage.objects.delete","storage.objects.get","storage.objects.list"]
}


resource "google_project_iam_custom_role" "object-signer" {
  role_id     = var.presigned-iam-object-signer 
  title       = "presigning role"
  description = "This is the role necessary to allow the function to create a presigned url for an object"
  permissions = ["iam.serviceAccounts.signBlob"]
}



## This binds the policy to the bucket which stores the objects to sign.

resource "google_project_iam_binding" "storage-binding" {
  project = var.project-name
  role    = "projects/${var.project-name}/roles/${google_project_iam_custom_role.presigned-url-storage.role_id}"
  members = [
    "serviceAccount:${google_service_account.function-executor.email}"
  ]
condition {
      title       = "bucket policy for cloud run function"
      description = "allows access to GCS"
      expression  = "resource.name.startsWith(\"projects/_/buckets/${var.presigned-url-bucket}\")"
  }
}

resource "google_project_iam_binding" "object-signer" {
  project = var.project-name
  role    = "projects/${var.project-name}/roles/${google_project_iam_custom_role.object-signer.role_id}"

  members = [
   "serviceAccount:${google_service_account.function-executor.email}"
  ]

}
