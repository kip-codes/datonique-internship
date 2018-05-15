# File: jp_extract
# Project: kevinip-sandbox
# Local author: kevinip
# Created on 05/07/2018 at 10:14 AM
#
# For inquiries about the file please contact the author.


import json, requests, datetime, time, os
import jp_extract_functions as jp_extract
import jp_extract_cleanup as jp_clean
import boto3  # upload JSON to S3 Bucket

today = datetime.datetime.now()
todayfn = str(today.month) + '-' + str(today.day) + '-' + str(today.year)


def extract():
    """Main function"""
    # List of nodes to export
    nodes = ['customers', 'orders', 'products']
    creds = jp_extract.takeCredentials()


    while True:
        nodetype = jp_extract.takeNode(nodes)
        intermediate_url = jp_extract.makeURL(creds, nodetype)

        try:
            print("Attempting to connect to URL...")
            json_obj = requests.get(intermediate_url, auth=(creds['api_key'], creds['pw']))
        except requests.HTTPError as err:
            print(err,"Connection failure.")
            quit()
        print("Connected.")

        if input("Print results? (y/n): ") in ('y', 'yes'):
            print('\n', json_obj.headers['content-type'], json_obj.encoding)
            print(json.dumps(json_obj.json(), indent=4, sort_keys=True))

        # Write to file
        cq1 = input("\nWrite to file? (y/n): ")
        if cq1 in ('y', 'yes'):
            print("Writing...")
            ofilename = (str(today.month) + '-' + str(today.day) + '-' + str(today.year) + 'jp_' + nodetype + '.json')
            with open(ofilename, 'w') as ofile:
                json.dump(json_obj.json(), ofile)
            print("Write successful.")
            nodes.remove(nodetype)   # removes the node that has been successfully exported
            if nodes:  # There are still nodes that have not been exported
                cq2 = input("\nWould you like to export another node? (y/n): ")
                if cq2 in ('y', 'yes'):
                    continue  # restart input query for node
                elif cq2 in ('n', 'no'):
                    return
                else:
                    print("Invalid response.")
            else:  # all nodes have been exported
                print("\nYou have exported all three nodes. Proceeding to cleanup...")
                time.sleep(2)
                return
        elif cq1 in ('n', 'no'):  # User chooses to exit program
            print("Exiting...")
            time.sleep(2)
            return
        else:
            print("Invalid response.")


def cleanup():
    return jp_clean.main()


def uploadToS3():
    print(os.getcwd())
    import boto3
    from botocore.client import Config

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
            print("\n{} has been successfully uploaded.".format(node))

    print("\nDone")


def removeExtracts():
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
    print('\n' + str(fcount) + ' files removed. Returning to main menu...\n')
    time.sleep(1)




if __name__ == '__main__':
    while True:
        c = input("Would you like to:"
                  "\n1. Extract JSON from API"
                  "\n2. Clean up JSON for Redshift"
                  "\n3. Upload reformatted JSON to S3"
                  "\n4. Delete raw JSON exports from local directory"
                  "\n('q' to exit)\n")
        if c == 'q':
            print("Exiting...")
            time.sleep(1)
            quit()
        if c == '1': extract()
        if c == '2': cleanup()
        if c == '3': uploadToS3()
        if c == '4': removeExtracts()
