# File: jp_extract
# Project: kevinip-sandbox
# Local author: kevinip
# Created on 05/07/2018 at 10:14 AM
#
# For inquiries about the file please contact the author.


import json, requests, datetime, time, os, sys, logging
import jp_extract_functions as jp_extract
import jp_extract_cleanup as jp_clean

today = datetime.datetime.now()
todayfn = str(today.month) + '-' + str(today.day) + '-' + str(today.year)


def strike(text):
    result = ''
    for c in text:
        result = result + c + '\u0336'
    return result


def extract(choices=None, credentials=None, admin=False):
    """Main function"""
    # List of nodes to export
    nodes = ['customers', 'orders', 'products']
    creds = {}

    if credentials:
        with open(credentials, 'r') as infile:
            lines = []
            for l in infile:
                lines.append(l)
            if len(lines) == 3:
                creds = {'storeurl':lines[0].strip(), 'pw':lines[1].strip(), 'api_key':lines[2].strip()}
    else:
        creds = jp_extract.takeCredentials()

    # Starting message
    print("Beginning API extraction for store: " + creds['storeurl'] + '.\n')

    while True:
        nodetype = jp_extract.takeNode(nodes, admin)
        intermediate_url = jp_extract.makeURL(creds, nodetype)

        try:
            print("Attempting to connect to URL for " + nodetype.upper() + "...")
            json_obj = requests.get(intermediate_url, auth=(creds['api_key'], creds['pw']))
        except requests.HTTPError as err:
            print(err,"Connection failure.")
            quit()
        print("Connected.")

        if admin:
            if input("Print results? (y/n): ") in ('y', 'yes'):
                print('\n', json_obj.headers['content-type'], json_obj.encoding)
                print(json.dumps(json_obj.json(), indent=4, sort_keys=True))

        # Write to file
        if admin:
            cq1 = input("\nWrite to file? (y/n): ")
        else:
            cq1 = 'y'
        if cq1 in ('y', 'yes'):
            print("Writing...")
            ofilename = (str(today.month) + '-' + str(today.day) + '-' + str(today.year) + 'jp_' + nodetype + '.json')
            with open(ofilename, 'w') as ofile:
                json.dump(json_obj.json(), ofile)
                logging.info(json_obj.json())
            print("Write successful.\n")
            nodes.remove(nodetype)   # removes the node that has been successfully exported
            if nodes:  # There are still nodes that have not been exported
                if not admin:
                    continue
                else:  # if admin walkthrough
                    cq2 = input("\nWould you like to export another node? (y/n): ")
                    if cq2 in ('y', 'yes'):
                        continue  # restart input query for node
                    elif cq2 in ('n', 'no'):
                        return
                    else:
                        print("Invalid response.")
            else:  # all nodes have been exported
                print("\nAll three nodes have been exported. Proceeding to cleanup...\n")
                if choices:
                    choices.remove(1)
                time.sleep(2)
                return
        elif cq1 in ('n', 'no'):  # User chooses to exit program
            print("Exiting...")
            time.sleep(2)
            return
        else:
            print("Invalid response.")


def cleanup(choices=None, admin=False):
    return jp_clean.main(choices, admin)


def uploadToS3(choices=None, credentials=None):
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

    nodes = ['customers','orders','products','lineitems']

    while nodes:
        for node in nodes:
            # This is the name of the bucket on S3.
            BUCKET_NAME = 'kevin-ip'

            # This is the subdirectory path inside the S3 Bucket.
            KEY = 'jakepaulofficial/' + node + '/' + todayfn + 'jp_' + node + '_cleaned.json'

            # This is the local path to the file you want to upload.
            FILE_NAME = node + '-cleaned/' + todayfn + 'jp_' + node + '_cleaned.json'
            try:
                data = open(FILE_NAME, 'rb')  # check if file exists
            except:
                print("WARNING: A valid file for " + node.upper() + " was not found. Proceeding to other nodes...")
                nodes.remove(node)
                time.sleep(1)
                continue

            data = open(FILE_NAME, 'rb')
            # JSON Uploaded
            s3.Bucket(BUCKET_NAME).put_object(Key=KEY, Body=data, ACL='authenticated-read')
            nodes.remove(node)
            print("{} has been successfully uploaded.".format(node.upper()))

    if choices:
        choices.remove(3)
    print("\nAll nodes have been successfully uploaded to the bucket '" + BUCKET_NAME + "'. Proceeding to directory cleanup...")


def removeExtracts(choices=None):
    print("Removing old extracts from your directory...\n")

    nodes = ['customers', 'orders', 'products']
    fcount = 0
    for n in nodes:
        try:
            fn = todayfn + 'jp_' + n + '.json'
            f = open(fn)
            f.close()
        except FileNotFoundError:
            print('\nFile for ' + n.upper() + ' does not exist.')
            continue
        os.remove(fn)
        print(n.upper() + ' has been deleted from your directory.')
        fcount += 1

    if choices:
        choices.remove(4)
    print('\n{} files removed. Returning to main menu...'.format(str(fcount)))
    time.sleep(1)


def main():
    logging.basicConfig(filename='jp_extract' + str(time.time()) + '-debug.log', level=logging.DEBUG)

    choices = [1, 2, 3, 4]

    # Simple script, automatically complete all procedures but require user input
    if len(sys.argv) == 1:
        extract()
        cleanup()
        uploadToS3()
        removeExtracts()

    # Admin ; allow user to choose which procedures to undergo
    if len(sys.argv) == 2 and sys.argv[1] == 'admin':
        while True:
            print("\nWould you like to:")
            if 1 in choices:
                print("1. Extract JSON from API")
            else:
                print(strike("1. Extract JSON from API"))
            if 2 in choices:
                print("2. Clean up JSON for Redshift")
            else:
                print(strike("2. Clean up JSON for Redshift"))
            if 3 in choices:
                print("3. Upload reformatted JSON to S3")
            else:
                print(strike("3. Upload reformatted JSON to S3"))
            if 4 in choices:
                print("4. Delete raw JSON exports from local directory")
            else:
                print(strike("4. Delete raw JSON exports from local directory"))

            c = input("\n('q' to exit)\n>>\t")
            if c == 'q' or not choices:
                print("Exiting...")
                time.sleep(1)
                quit()
            if c == '1':
                extract(choices, admin=True)
            if c == '2': cleanup(choices, admin=True)
            if c == '3': uploadToS3(choices)
            if c == '4': removeExtracts(choices)

    # Simple script, with all credentials provided.
    if len(sys.argv) == 3 and sys.argv[1] != 'admin':
        extract(credentials=sys.argv[1])
        cleanup()
        uploadToS3(credentials=sys.argv[2])
        removeExtracts()

    else:
        print("usage: <script.py> [store name] [store password] [store API] [AWS access] [AWS secret access]")

    print("Done.")


if __name__ == '__main__':
    main()