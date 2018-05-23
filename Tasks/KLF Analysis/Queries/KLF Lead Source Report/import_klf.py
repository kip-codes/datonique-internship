# File: import_klf
# Project: kevinip-sandbox
# Local author: kevinip
# Created on 05/16/2018 at 12:34 PM
#
# For inquiries about the file please contact the author.


import datetime, time, os, sys, logging
import boto3, psycopg2, botocore.exceptions
from botocore.client import Config


today = datetime.datetime.now()
yday = today - datetime.timedelta(days=1)
yesterdayfn = str(yday.month) + '-' + str(yday.day) + '-' + str(yday.year)

def get_S3_Key():
    """Acquire the newest file within the target S3 subdirectory."""

    ACCESS_KEY_ID = os.environ['ACCESS_KEY_ID']
    ACCESS_SECRET_KEY = os.environ['ACCESS_SECRET_KEY']

    # Create an S3 object
    s3 = boto3.resource(
        's3',
        aws_access_key_id=ACCESS_KEY_ID,
        aws_secret_access_key=ACCESS_SECRET_KEY,
        config=Config(signature_version='s3v4')
    )

    # This is the name of the bucket on S3.
    BUCKET = 'kevin-ip'

    # This is the subdirectory path inside the S3 Bucket, including the name of the file you want.
    get_last_modified = lambda obj: int(obj['LastModified'].strftime('%s'))

    objs = s3.list_objects_v2(Bucket=BUCKET)['Contents']
    last_added = [obj['Key'] for obj in sorted(objs, key=get_last_modified)][-1]

    KEY = 'klf/' + last_added
    try:
        s3.Object(BUCKET, KEY).load()
    except botocore.exceptions.ClientError as e:
        if e.response['Error']['Code'] == "404":
            # The object does not exist.
            print("The object under " + KEY + " does not exist.")
            quit()
        else:
            # Something else has gone wrong.
            raise
    else:
        # The object does exist.
        print("Attempt to load S3 object failed with no exception raised.")
        quit()

    return [BUCKET, KEY]


def load_psql_query(s3_array):
    print("Importing S3 file into Redshift...")

    schema = 'klf'

    # REDSHIFT LOAD
    if s3_array:
        table = 'leads_source_report'
        delete = None
        copy = """
                copy {schematable}
                from 's3://{bucket}/{key}'
                credentials 'aws_access_key_id={aws_key};aws_secret_access_key={aws_secret}'
                CSV
                IGNOREHEADER 1
                DELIMITER ','
                ACCEPTINVCHARS AS '?'
                NULL as 'NULL'
                REGION AS 'ap-south-1';
                """.format(
            schematable='{}.{}'.format(schema, table),
            bucket= s3_array[0],
            key= s3_array[1],
            aws_key=os.environ['ACCESS_KEY_ID'],
            aws_secret=os.environ['ACCESS_SECRET_KEY']
            )
        # Execute formatted query
        s3_to_redshift_write(s3_array[1], copy, delete)
    else:
        print("ERROR:\tCOPY to Redshift failed.\n")


def s3_to_redshift_write(key, copy, delete = None):
    user = os.environ['REDSHIFT_USER']
    password = os.environ['REDSHIFT_PASSWORD']
    host = os.environ['REDSHIFT_HOST']
    database = os.environ['REDSHIFT_DATABASE']
    port = os.environ['REDSHIFT_PORT']
    db = psycopg2.connect(
        database=database,
        user=user,
        password=password,
        host=host,
        port=port
    )
    cur = db.cursor()
    print("Connection established to database.")

    if delete:
        cur.execute(delete)
    cur.execute(copy)
    db.commit()
    cur.close()
    db.close()

    print("\tCOPY command for {} was successful.\n".format(key))


def lambda_handler(event=None, context=None):
    # logging.basicConfig(filename=__name__ + str(time.time()) + '-debug.log', level=logging.DEBUG)
    load_psql_query(get_S3_Key())
