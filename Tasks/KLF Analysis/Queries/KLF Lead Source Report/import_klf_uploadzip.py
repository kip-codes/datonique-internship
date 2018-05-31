# File: import_klf_uploadzip
# Project: kevinip-sandbox
# Local author: kevinip
# Created on 05/31/2018 at 11:45 AM
#
# For inquiries about the file please contact the author.


import os
import boto3
from botocore.client import Config

if __name__ == '__main__':
    ACCESS_KEY_ID = os.environ['ACCESS_KEY_ID']
    ACCESS_SECRET_KEY = os.environ['ACCESS_SECRET_KEY']

    print("Beginning upload to default S3 bucket...\n")

    # S3 Connect
    s3 = boto3.resource(
        's3',
        aws_access_key_id=ACCESS_KEY_ID,
        aws_secret_access_key=ACCESS_SECRET_KEY,
        config=Config(signature_version='s3v4')
    )

    # This is the name of the bucket on S3.
    BUCKET = 'kevin-ip-datonique'

    # This is the subdirectory path inside the S3 Bucket, including the name of the file you want.
    KEY = 'klf/import_klf.zip'

    data = '/Users/kevinip/Desktop/Datonique/import_klf.zip'

    # ZIP file Uploaded
    s3.Bucket(BUCKET).upload_file(data, Key=KEY)
    print("Done.")