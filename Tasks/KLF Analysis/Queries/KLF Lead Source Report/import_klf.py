# File: import_klf
# Project: kevinip-sandbox
# Local author: kevinip
# Created on 05/16/2018 at 12:34 PM
#
# For inquiries about the file please contact the author.


import datetime, time, os, sys, logging

today = datetime.datetime.now()
todayfn = str(today.month) + '-' + str(today.day) + '-' + str(today.year)



def uploadToS3(credentials=None):
    import boto3
    from botocore.client import Config

    ACCESS_KEY_ID=''
    ACCESS_SECRET_KEY=''

    print("Beginning upload to default S3 bucket...\n")

    if credentials:
        with open(credentials, 'r') as infile:
            lines = []
            for l in infile:
                lines.append(l)
            if len(lines) == 2:
                ACCESS_KEY_ID = lines[0].strip()
                ACCESS_SECRET_KEY = lines[1].strip()
            else:
                print("Improper formatting for AWS credential file. Proceeding to manual input.")
                ACCESS_KEY_ID = input("Enter your AWS Access Key:\t")
                ACCESS_SECRET_KEY = input("Enter your AWS Secret Access Key:\t")
    else:
        ACCESS_KEY_ID = input("Enter your AWS Access Key:\t")
        ACCESS_SECRET_KEY = input("Enter your AWS Secret Access Key:\t")

    # S3 Connect
    s3 = boto3.resource(
        's3',
        aws_access_key_id=ACCESS_KEY_ID,
        aws_secret_access_key=ACCESS_SECRET_KEY,
        config=Config(signature_version='s3v4')
    )

    # This is the name of the bucket on S3.
    BUCKET_NAME = 'kevin-ip'

    # This is the subdirectory path inside the S3 Bucket, ending in the desired file name for S3
    KEY = 'KLF/' + todayfn + 'Leads-Source-Report.csv'

    # Get name of .csv file in directory
    onlyfiles = [f for f in os.listdir('Reports/') if os.path.isfile(os.path.join('Reports/', f))]
    print(onlyfiles)

    # This is the local path to the file you want to upload.
    FILE_NAME = 'Reports/' + todayfn + '_Leads-Source-Report.csv'
    try:
        data = open(FILE_NAME, 'rb')  # check if file exists
    except:
        print("WARNING: A valid file for " + FILE_NAME + " was not found. Exiting...")
        time.sleep(1)
        return

    data = open(FILE_NAME, 'rb')
    # CSV Uploaded
    s3.Bucket(BUCKET_NAME).put_object(Key=KEY, Body=data, ACL='authenticated-read')
    print("{} has been successfully uploaded.".format(FILE_NAME))

    print("\nAll nodes have been successfully uploaded to the bucket '" + BUCKET_NAME + "'.")



def main():
    uploadToS3()


if __name__ == '__main__':
    main()