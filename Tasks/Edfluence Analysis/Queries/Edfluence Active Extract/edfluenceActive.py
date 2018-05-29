# File: edfluence_active_extract
# Project: kevinip-sandbox
# Local author: kevinip
# Created on 05/29/2018 at 1:18 PM
#
# For inquiries about the file please contact the author.

import psycopg2
import pymysql
import csv
import boto3
from botocore.client import Config
import os, io, datetime

today = datetime.datetime.now()
todayfn = str(today.month) + '-' + str(today.day) + '-' + str(today.year)


def csvString(csv_data):
    with io.StringIO() as f:
        for entry in csv_data:
            f.write("%s\n" % entry)
        return f.getvalue()


def getMySQLData():
    """Extracts Active Edfluence users from a MySQL database."""
    host = os.environ['MYSQL_HOST']
    user = os.environ['MYSQL_USERNAME']
    password = os.environ['MYSQL_PASSWORD']
    database = os.environ['MYSQL_DATABASE']
    port = os.environ['MYSQL_PORT']

    # Get data from MySQL
    print("Connecting to MySQL Database...")
    mysql_conn = pymysql.connect(host=host, port=3306, user=user, password=password, database=database)
    mysql_cur = mysql_conn.cursor()
    if mysql_cur:
        print("Connected.")

    # Extract active users from Edfluence
    print("Extracting data from MySQL table...")
    mysql_cur.execute(
        """
        select DISTINCT trim(lower(user_email)) as email
        from wordpress.wp_users
        where id IN
        (
          SELECT distinct user_id
          FROM wordpress.wp_pmpro_memberships_users
          WHERE status = 'active'
        );
        """
    )

    description = mysql_cur.description  # 'description' contains the headers of this MySQL query
    rows = mysql_cur.fetchall()  # 'rows' contains the results of the MySQL query

    results=[]
    for r in rows:
        results.append(r[0])  # Remove tuple property and append results as a list

    mysql_conn.close()
    mysql_cur.close()

    if description and results:
        print("Extraction completed.")
        return results
    else:
        print("MySQL Extraction failed.")


def uploadToS3(mysql_result, choices=None, credentials=None):
    """Creates virtual file of SQL query results and uploads as .csv to S3 bucket."""
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
    BUCKET = 'kevin-ip'

    # This is the subdirectory path inside the S3 Bucket, including the name of the file you want.
    KEY = 'edfluence/' + todayfn + 'Edfluence_active.csv'

    # This is the local path to the file you want to upload.
    data = csvString(mysql_result)

    # CSV Uploaded
    s3.Bucket(BUCKET).put_object(Key=KEY, Body=data, ACL='authenticated-read')
    print("\t{} has been successfully uploaded.\n".format("The MySQL result for Edfluence"))

    # Import S3 data into Redshift
    load_psql_query(BUCKET, KEY)


def load_psql_query(BUCKET, KEY):
    """Format Redshift COPY command."""
    schema = 'kevin_ip'

    # REDSHIFT LOAD
    table = 'edfluence_active'
    delete = "truncate {}.{};".format(schema, table)
    copy = """
            COPY {schematable}
            FROM 's3://{bucket}/{key}'
            CREDENTIALS 'aws_access_key_id={aws_key};aws_secret_access_key={aws_secret}'
            CSV DELIMITER ',';
            """.format(
        schematable='{}.{}'.format(schema, table),
        bucket=BUCKET,
        key=KEY,
        aws_key=os.environ['ACCESS_KEY_ID'],
        aws_secret=os.environ['ACCESS_SECRET_KEY']
    )

    s3_to_redshift_write(copy, delete)


def s3_to_redshift_write(copy, delete = None):
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

    print("\tCOPY command for {} was successful.\n".format("Edfluence Active"))



def lambda_handler(event=None, context=None):
    result = getMySQLData()  # List of description and rows
    if result:
        uploadToS3(result)
    else:
        print("MySQL extraction failed.")

    print("\nDone.")


if __name__ == '__main__':
    result = getMySQLData()  # List of description and rows
    if result:
        uploadToS3(result)
    else:
        print("MySQL extraction failed.")

    print("\nDone.")