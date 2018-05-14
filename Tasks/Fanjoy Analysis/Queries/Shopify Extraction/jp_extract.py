# File: jp_extract
# Project: kevinip-sandbox
# Local author: kevinip
# Created on 05/07/2018 at 10:14 AM
#
# For inquiries about the file please contact the author.


import json, requests, datetime, time
import jp_extract_functions as jp_extract
import jp_extract_cleanup as jp_clean
import boto3  # upload JSON to S3 Bucket

today = datetime.datetime.now()


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
    jp_clean.main()


if __name__ == '__main__':
    extract()
    cleanup()