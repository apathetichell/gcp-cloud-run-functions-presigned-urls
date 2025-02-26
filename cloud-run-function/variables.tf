variable "function-service-account-email" {
  description = "service account for executing the cloud run function"
  default= "tf-presigned-url-exector"
  type        = string
}


variable "function-bucket"{
  description ="this is the bucket which stores the .zip files of the cloud run function"
}

variable "presigned-url-bucket" {
  description = "specific bucket where objects that need to be signed will be"
  default= "tf-bucket-for-signed-objects"
  type        = string
}

variable "function-name" {
  description= "name of the presigned url function"
  default="tf-presigned-url-generator"
  type=string
}

variable "project_location" {
  description="default locations of storage bucket for the code and for the cloud run function"
  default="us-central1"
  type=string
}

variable "random_file_number"{
  description="random number used for different function runs"
  default="1"
  type=string
}