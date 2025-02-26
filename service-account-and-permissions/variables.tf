variable "function-service-account" {
  description = "service account for executing the cloud run function"
  default= "tf-presigned-url-exector"
  type        = string
}


## policy which will be used for allocating an AWS resource to GCP
variable "presigned-url-storage-object-user" {
  description = "storage role for presigned urls"
  default= "tf_presigned_url_storage_object_user"
  type        = string
}

variable "presigned-iam-object-signer" {
  description = "specific iam permission for signing objects"
  default= "tf_presigned_iam_object_signer"
  type        = string
}

variable "presigned-url-bucket" {
  description = "specific bucket where objects that need to be signed will be"
  default= "tf-bucket-for-signed-objects"
  type        = string
}

variable "project-id" {
    description= "this is the project id"
    type= string
}

variable "project-name" {
    description="this is the project name"
    type= string
}










//var.function_service_account


//role->"presigned-url-storage-object-user" default

//role->"presigned-iam-object-signer" default