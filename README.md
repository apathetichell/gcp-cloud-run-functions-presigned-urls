# gcp-cloud-run-functions-presigned-urls
TF repo for deploying a cloud run function (gen 2/Python) which signs GCS storage objects without static storage account keys.


GCP documents how to create presigned urls for GCS objects in a variety of languages here:
https://cloud.google.com/storage/docs/samples/storage-generate-signed-url-v4#storage_generate_signed_url_v4-python

Unlike some other languages (Node.js for example) the credentials created by Google Auth cannot natively be used to sign objects. Google notes:
    """Generates a v4 signed URL for downloading a blob.

    Note that this method requires a service account key file. You can not use
    this if you are using Application Default Credentials from Google Compute
    Engine or from the Google Cloud SDK.
    """
This repo includes code to create a function to sign objects and provision the related infra (GCP service account, GCP roles, binding of roles to service account) to sign objects.
    
