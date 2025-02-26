import datetime
import functions_framework
import json
import google.auth
import google.auth.transport.requests
import os

from google.cloud import storage


def get_credentials():
    print('generating credentials')
    """This function is used to generate the credentials for the service account running the Cloud Run Function
        see the TF modules for permissions required for this service account
    """
    
    
    scopes = ["https://www.googleapis.com/auth/devstorage.read_write","https://www.googleapis.com/auth/iam"]
    credentials, project = google.auth.default(scopes=scopes)


    if credentials.token is None:
        credentials.refresh(google.auth.transport.requests.Request())
    return credentials



def generate_download_signed_url(bucket_name, blob_name,credentials):
    """Generates a v4 signed URL for downloading a blob.
     """


    storage_client = storage.Client(credentials=credentials)
    bucket = storage_client.bucket(bucket_name)
    blob = bucket.blob(blob_name)

    print(blob_name,bucket_name)
    print('entering object signing function')
    url = blob.generate_signed_url(
        version="v4",
        # This URL is valid for 15 minutes
        expiration=datetime.timedelta(minutes=15),
        service_account_email=credentials.service_account_email,
        access_token=credentials.token,
        
        # Allow GET requests using this URL.
        method="GET",
    )

    print("Generated GET signed URL:")
    ##print(url)
    ##print("You can use this URL with any user agent, for example:")
    ##print(f"curl '{url}'")
    return url


@functions_framework.http
def sign_GCS_object(request):

    request_json = request.get_json(silent=True)
    request_args = request.args

    credentials=get_credentials()
    if request_json and 'bucket' in request_json:
        bucket = request_json['bucket']
    else:
        bucket = os.environ.get('bucket')
    
    if request_json and 'object' in request_json:
        object=request_json['object']
        url=generate_download_signed_url(bucket,object,credentials)
        message=url
    else:
        message = 'error - no object was found in the bucket payload'
    
    data = {
        
        'uri':message,
        'status': 'ok',
        'filename':object,
        'bucket':bucket
    }

    return json.dumps(data), 200, {'Content-Type': 'application/json'}