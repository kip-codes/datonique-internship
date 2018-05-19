# File: jp_extract
# Project: kevinip-sandbox
# Local author: kevinip
# Created on 05/07/2018 at 10:14 AM
#
# For inquiries about the file please contact the author.


import json, requests, datetime, time, os, sys, logging, io, psycopg2
import jp_extract_functions as jp_extract
import jp_extract_cleanup as jp_clean

today = datetime.datetime.now()
todayfn = str(today.month) + '-' + str(today.day) + '-' + str(today.year)


def jsonString(json_collection):
    with io.StringIO() as f:
        for entry in json_collection:
            f.write("%s\n" % json.dumps(entry))
        return f.getvalue()


def extract(choices=None, credentials=None, admin=False):
    """Main function"""

    # List of nodes to export
    nodes = ['customers', 'orders', 'products']

    # Take credentials
    STOREURL = os.environ['STOREURL']
    STOREPW = os.environ['STOREPW']
    STOREAPI = os.environ['STOREAPI']
    creds = {
        'storeurl': STOREURL,
        'pw': STOREPW,
        'api_key': STOREAPI
    }

    # Starting message
    print("Beginning API extraction for store: " + creds['storeurl'] + '.\n')

    # Process each Shopify node
    while True:
        nodetype = jp_extract.takeNode(nodes, admin)
        intermediate_url = jp_extract.makeURL(creds, nodetype)
        json_obj = {}

        try:
            print("Attempting to connect to URL for " + nodetype.upper() + "...")
            json_obj = requests.get(intermediate_url, auth=(creds['api_key'], creds['pw']))
        except requests.HTTPError as err:
            print(err,"Connection failure.")
            quit()
        print("Connected.")

        # Clean the JSON and upload directly to S3
        cleanup(json_obj.json(), nodetype)
        nodes.remove(nodetype)   # removes the node that has been successfully exported

        if nodes:  # There are still nodes that have not been exported
            continue
        else:  # exported all 3 nodes
            return


def cleanup(json_obj, nodetype):
    # Cleanup file and upload to S3
    print("Cleaning up " + nodetype.upper() + "...")

    if nodetype == 'customers':
        uploadToS3(jp_clean.cleanupCustomers_lambda(json_obj), 'customers')
    if nodetype == 'orders':  # Need to cleanup twice for orders and line items
        uploadToS3(jp_clean.cleanupOrders_lambda(json_obj), 'orders')
        uploadToS3(jp_clean.cleanupLineItems_lambda(json_obj), 'lineitems')
    if nodetype == 'products':
        uploadToS3(jp_clean.cleanupProducts_lambda(json_obj), 'products')


def uploadToS3(json_arr, node, choices=None, credentials=None):
    import boto3
    from botocore.client import Config

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
    KEY = 'jakepaulofficial/' + node + '/' + todayfn + 'jp_' + node + '_cleaned.json'

    # This is the local path to the file you want to upload.
    data = jsonString(json_arr)

    # JSON Uploaded
    s3.Bucket(BUCKET).put_object(Key=KEY, Body=data, ACL='authenticated-read')
    print("\t{} has been successfully uploaded.\n".format(node.upper()))

    load_psql_query(BUCKET, KEY, node)


def load_psql_query(BUCKET, KEY, node):
    print("Importing S3 file into Redshift...")

    schema = 'kevin_ip'

    # REDSHIFT LOAD
    if node == 'customers':
        table = 'jpofficial_customers'
        delete = "truncate {}.{};".format(schema, table)
        copy = """
                copy {schematable}
                from 's3://{bucket}/{key}'
                credentials 'aws_access_key_id={aws_key};aws_secret_access_key={aws_secret}'
                JSON 'auto'
                TIMEFORMAT 'auto';
                """.format(
            schematable='{}.{}'.format(schema, table),
            bucket= BUCKET,
            key= KEY,
            aws_key=os.environ['ACCESS_KEY_ID'],
            aws_secret=os.environ['ACCESS_SECRET_KEY']
            )
    elif node == 'orders':
        table = 'jpofficial_orders'
        delete = "truncate {}.{}".format(schema, table)
        copy = """
                copy {schematable}
                from 's3://{bucket}/{key}'
                credentials 'aws_access_key_id={aws_key};aws_secret_access_key={aws_secret}'
                JSON 'auto'
                TIMEFORMAT 'auto';
                """.format(
            schematable='{}.{}'.format(schema, table),
            bucket=BUCKET,
            key=KEY,
            aws_key=os.environ['ACCESS_KEY_ID'],
            aws_secret=os.environ['ACCESS_SECRET_KEY']
        )
    elif node == 'products':
        table = 'jpofficial_products'
        delete = "truncate {}.{}".format(schema, table)
        copy = """
                copy {schematable}
                from 's3://{bucket}/{key}'
                credentials 'aws_access_key_id={aws_key};aws_secret_access_key={aws_secret}'
                JSON 'auto'
                TIMEFORMAT 'auto';
                """.format(
            schematable='{}.{}'.format(schema, table),
            bucket=BUCKET,
            key=KEY,
            aws_key=os.environ['ACCESS_KEY_ID'],
            aws_secret=os.environ['ACCESS_SECRET_KEY']
        )
    elif node == 'lineitems':
        table = 'jpofficial_lineitems'
        delete = "truncate {}.{}".format(schema, table)
        copy = """
                copy {schematable}
                from 's3://{bucket}/{key}'
                credentials 'aws_access_key_id={aws_key};aws_secret_access_key={aws_secret}'
                JSON 'auto'
                TIMEFORMAT 'auto';
                """.format(
            schematable='{}.{}'.format(schema, table),
            bucket=BUCKET,
            key=KEY,
            aws_key=os.environ['ACCESS_KEY_ID'],
            aws_secret=os.environ['ACCESS_SECRET_KEY']
        )
    else:
        print("ERROR:\tCOPY to Redshift failed.\n")

    # Execute formatted query
    s3_to_redshift_write(node, copy, delete)



def s3_to_redshift_write(node, copy, delete = None):
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

    print("\tCOPY command for {} was successful.\n".format(node.upper()))



def lambda_handler(event=None, context=None):
    # Simple script, with all credentials provided, assuming AWS Lambda will provide as environment variables.
    extract()

    print("Done.")


if __name__ == '__main__':
    lambda_handler()