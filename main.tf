data "google_project" "project" {
}

data "google_client_config" "this" {}



locals {
  project_number=data.google_project.project.number
  project_name=data.google_client_config.this.project
  project_location=data.google_client_config.this.region
}

output "project_number" {
  value = local.project_number
}

output "project_name" {
  value=local.project_name
}

resource "random_id" "default" {
  byte_length = 8
}

/*

## If you do not have a bucket to place objects in to sign -> run this module.

resource "google_storage_bucket" "object_bucket"{
    name=lower("tf-bucket-for-signed-objects-${random_id.default.id}") ##note - this is a generic bucket name but should be replaced by your specific bucket
    location=local.project_location
}

*/

module "gcp-service-accounts-roles" {
    source = "./service-account-and-permissions"
    
    project-id=local.project_number
    project-name=local.project_name

    ##---- note --> the assumption is that this bucket already exists and you should add your existing bucket here.
    presigned-url-bucket=lower("tf-bucket-for-signed-objects-${random_id.default.id}")


}

module "cloud-run-function" {
  source="./cloud-run-function"

  function-bucket=lower("tf-function-storage-bucket-${random_id.default.id}")
  function-service-account-email = module.gcp-service-accounts-roles.service_account_email

  random_file_number = lower(random_id.default.id)

  ##---- note --> the assumption is that this bucket already exists and you should add your existing bucket here.
  presigned-url-bucket=lower("tf-bucket-for-signed-objects-${random_id.default.id}")


    depends_on = [module.gcp-service-accounts-roles]

}

output "function_uri" {
  value = module.cloud-run-function.function_uri
}