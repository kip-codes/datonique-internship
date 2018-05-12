# File: test-json
# Project: kevinip-sandbox
# Local author: kevinip
# Created on 05/07/2018 at 4:22 PM
#
# For inquiries about the file please contact the author.

import json, datetime, os
from pathlib import Path

try:
    import cPickle as pickle
except ImportError:  # python 3.x
    import pickle


today = datetime.datetime.today()

def cleanupCustomers():
    """Cleanup customers.json"""

    with open('5-10-2018jp_customers.json', 'r') as f:
        data = json.load(f)
        print(json.dumps(data, indent=4, sort_keys=True))

        # Define a new list to contain collapsed dictionaries from source
        newDictStorage = []

        # Print data to be cleaned up
        for n in data['customers']: # each element is a distinct customer
            newDict = {}
            for key in n: # list of left hand keys
                if type(n[key]) is list: print('this is a list!')
                elif type(n[key]) is not dict: # valid folding
                    # print(type(n[key]), key, n[key])
                    newDict[key] = n[key]
                    # print(newDict[key])
            for key in n:
                if type(n[key]) is dict and key == 'default_address': # overwrite with dict values, usually the default addres object.
                    print('Dictionary found! Folding...')
                    newDict['address1'] = n[key]['address1']
                    newDict['address2'] = n[key]['address2']
                    newDict['city'] = n[key]['city']
                    newDict['company'] = n[key]['company']
                    newDict['country'] = n[key]['country']
                    newDict['default'] = n[key]['default']
                    newDict['phone'] = n[key]['phone']
                    newDict['province'] = n[key]['province']
                    newDict['zip'] = n[key]['zip']
            newDictStorage.append(newDict)

        print(newDictStorage)
        print(json.dumps(newDictStorage, indent=4, sort_keys=True))

        # Cleanup data so that it can be read by a COPY command using auto
        c = input("Write data? (y/n): ")
        if c == 'y':
            ofilename = (str(today.month) + '-' + str(today.day) + '-' + str(today.year) + 'jp_customers_cleaned.json')
            objCount = 0
            with open(ofilename, 'w') as ofile:
                for obj in newDictStorage:
                    json.dump(obj, ofile)
                    ofile.write('\n')
                    objCount += 1
            print("Write successful. {} objects written.".format(objCount))
        else: print("exiting...")


def cleanupOrders():
    """Cleanup orders.json"""

    with open('5-10-2018jp_orders.json', 'r') as f:
        data = json.load(f)
        print(json.dumps(data, indent=4, sort_keys=True))

        # Define a new list to contain collapsed dictionaries from source
        newDictStorage = []

        # Print data to be cleaned up
        for n in data['orders']:  # each element is a distinct customer
            newDict = {}
            for key in n:  # list of left hand keys
                if type(n[key]) is list:
                    print('this is a list!')
                elif type(n[key]) is not dict:  # valid folding
                    # print(type(n[key]), key, n[key])
                    newDict[key] = n[key]
                    # print(newDict[key])
            for key in n:
                if type(n[key]) is dict and key == 'customer':  # overwrite with dict values, usually the default addres object.
                    print('Dictionary found! Folding...')
                    newDict['customer_id'] = n[key]['id']
                    newDict['customer_email'] = n[key]['email']
                    newDict['customer_created_at'] = n[key]['created_at']
                    newDict['customer_updated_at'] = n[key]['updated_at']
                    newDict['customer_first_name'] = n[key]['first_name']
                    newDict['customer_last_name'] = n[key]['last_name']
                    newDict['customer_orders_count'] = n[key]['orders_count']
                    newDict['customer_total_spent'] = n[key]['total_spent']
            newDictStorage.append(newDict)


        print(newDictStorage)
        print(json.dumps(newDictStorage, indent=4, sort_keys=True))


        # Cleanup data so that it can be read by a COPY command using auto
        c = input("Write data? (y/n): ")
        if c == 'y':
            ofilename = (str(today.month) + '-' + str(today.day) + '-' + str(today.year) + 'jp_orders_cleaned.json')
            objCount = 0
            with open(ofilename, 'w') as ofile:
                for obj in newDictStorage:
                    json.dump(obj, ofile)
                    ofile.write('\n')
                    objCount += 1
            print("Write successful. {} objects written.".format(objCount))
        else: print("exiting...")


def cleanupLineItems():
    """Cleanup orders.json and extract only line item data"""

    with open('5-10-2018jp_orders.json', 'r') as f:
        data = json.load(f)
        print(json.dumps(data, indent=4, sort_keys=True))

        # Define a new list to contain collapsed dictionaries from source
        newDictStorage = []

        # Print data to be cleaned up
        for n in data['orders']:  # each element is a distinct customer
            for key in n:
                if type(n[key]) is list and key == 'line_items':
                    for obj in n[key]: # obj is a dictionary
                        newDict = {}
                        for k in obj: # k is the key inside each line item
                            if type(obj[k]) is not dict and type(obj[k]) is not list:
                                newDict[k] = obj[k]

                        # After every key in this specific line item has been processed, append to object
                        newDictStorage.append(newDict)

        print(newDictStorage)
        print(json.dumps(newDictStorage, indent=4, sort_keys=True))


        # Cleanup data so that it can be read by a COPY command using auto
        c = input("Write data? (y/n): ")
        if c == 'y':
            ofilename = (str(today.month) + '-' + str(today.day) + '-' + str(today.year) + 'jp_lineitems_cleaned.json')
            objCount = 0
            with open(ofilename, 'w') as ofile:
                for obj in newDictStorage:
                    json.dump(obj, ofile)
                    ofile.write('\n')
                    objCount += 1
            print("Write successful. {} objects written.".format(objCount))
        else: print("exiting...")


def cleanupProducts():
    """Cleanup products.json"""

    with open('5-10-2018jp_products.json', 'r') as f:
        data = json.load(f)
        # print(json.dumps(data, indent=4, sort_keys=True))

        # Define a new list to contain collapsed dictionaries from source
        newDictStorage = []

        # Print data to be cleaned up
        for n in data['products']:  # each element is a distinct customer
            for key in n:
                if type(n[key]) is list and key == 'variants':  # overwrite with dict values, usually the default addres object.
                    print('Dictionary found! Folding...')
                    for obj in n[key]:  # obj is a dictionary
                        newDict = {}
                        newDict['id'] = n['id']
                        newDict['title'] = n['title']
                        newDict['vendor'] = n['vendor']
                        newDict['product_type'] = n['product_type']
                        newDict['created_at'] = n['created_at']
                        newDict['handle'] = n['handle']
                        newDict['updated_at'] = n['updated_at']
                        newDict['published_at'] = n['published_at']
                        newDict['tags'] = n['tags']
                        newDict['variant_id'] = obj['id']
                        newDict['variant_product_id'] = obj['product_id']
                        newDict['variant_title'] = obj['title']
                        newDict['variant_price'] = obj['price']
                        newDict['variant_sku'] = obj['sku']
                        newDict['variant_taxable'] = obj['taxable']
                        newDictStorage.append(newDict)  # need to append every variant


        print(newDictStorage)
        print(json.dumps(newDictStorage, indent=4, sort_keys=True))


        # Cleanup data so that it can be read by a COPY command using auto
        c = input("Write data? (y/n): ")
        if c == 'y':
            ofilename = (str(today.month) + '-' + str(today.day) + '-' + str(today.year) + 'jp_products_cleaned.json')
            objCount = 0
            with open(ofilename, 'w') as ofile:
                for obj in newDictStorage:
                    json.dump(obj, ofile)
                    ofile.write('\n')
                    objCount += 1
            print("Write successful. {} objects written.".format(objCount))
        else: print("exiting...")


if __name__ == '__main__':
    print(os.getcwd())

    c = input("\nChoose 1. Customers, 2. Orders, 3. Products. 4. Line items\n")
    if c == '1': cleanupCustomers()
    elif c == '2': cleanupOrders()
    elif c == '3': cleanupProducts()
    elif c == '4': cleanupLineItems()
    else: print("Wrong input. Exiting...")
