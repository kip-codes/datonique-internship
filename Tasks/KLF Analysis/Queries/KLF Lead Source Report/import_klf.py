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

    # Get name of .csv file(s) in directory
    onlyfiles = [f for f in os.listdir('Reports/') if not f.startswith('.') and os.path.isfile(os.path.join('Reports/', f))]

    if not onlyfiles:  # empty directory
        print("There are no files in the Reports directory to be uploaded.")
        return

    print(onlyfiles)

    objCount = 0
    for n,f in enumerate(onlyfiles):  # only 1 expected, but may take more
        # This is the subdirectory path inside the S3 Bucket, ending in the desired file name for S3
        KEY = 'klf/' + f

        # This is the local path to the file(s) you want to upload.
        FILE_NAME = 'Reports/' + f
        try:
            data = open(FILE_NAME, 'rb')  # check if file exists
        except:
            print("WARNING: A valid file for " + FILE_NAME + " was not found. Exiting...")
            time.sleep(1)
            return

        data = open(FILE_NAME, 'rb')

        # CSV Upload
        s3.Bucket(BUCKET_NAME).put_object(Key=KEY, Body=data, ACL='authenticated-read')
        print("{} has been successfully uploaded.".format(f))
        objCount += 1

    print("\n" + str(objCount) + " files uploaded.")
    print("All nodes have been successfully uploaded to the bucket '" + BUCKET_NAME + "'.")



def main():
    logging.basicConfig(filename=__name__ + str(time.time()) + '-debug.log', level=logging.DEBUG)


    uploadToS3()


if __name__ == '__main__':
    uploadToS3(sys.argv[1])