# File: test-json
# Project: kevinip-sandbox
# Local author: kevinip
# Created on 05/07/2018 at 4:22 PM
#
# For inquiries about the file please contact the author.

import json, datetime, os, time
from pathlib import Path


today = datetime.datetime.today()

def cleanupCustomers(admin=False):
    """Cleanup customers.json"""
    d = str(today.month) + '-' + str(today.day) + '-' + str(today.year)
    fn = d + 'jp_customers.json'
    print(fn)
    try:
        if (os.path.isfile(fn)):
            print("File found! Proceeding to cleanup...")
            time.sleep(1)
    except IOError:
        print("\nNo recent export for Customers found."
              "\nReturning...")
        return

    with open(fn, 'r') as f:
        data = json.load(f)
        # print(json.dumps(data, indent=4, sort_keys=True))

        # Define a new list to contain collapsed dictionaries from source
        newDictStorage = []

        # Print data to be cleaned up
        for n in data['customers']: # each element is a distinct customer
            newDict = {}
            for key in n: # list of left hand keys
                if type(n[key]) is not dict and type(n[key]) is not list: # valid folding
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

        # print(newDictStorage)
        # print(json.dumps(newDictStorage, indent=4, sort_keys=True))

        # Cleanup data so that it can be read by a COPY command using auto
        if not admin:
            c = 'y'
        else:
            c = input("Write data? (y/n): ")
        if c == 'y':
            ofiledir = '/Users/kevinip/Documents/POST GRAD/PyCharm Projects/kevinip-sandbox/Tasks/Fanjoy Analysis/Queries/Shopify Extraction/customers-cleaned/'
            ofilename = (str(today.month) + '-' + str(today.day) + '-' + str(today.year) + 'jp_customers_cleaned.json')
            fn = ofiledir + ofilename
            os.makedirs(ofiledir, exist_ok=True)
            objCount = 0
            with open(fn, 'w') as f:
                for obj in newDictStorage:
                    json.dump(obj, f)
                    f.write('\n')
                    objCount += 1
            print("Write successful. {} objects written.".format(objCount))
        else: print("Returning...")


def cleanupOrders(admin=False):
    """Cleanup orders.json"""
    d = str(today.month) + '-' + str(today.day) + '-' + str(today.year)
    fn = d + 'jp_orders.json'
    print(fn)
    try:
        if (os.path.isfile(fn)):
            print("File found! Proceeding to cleanup...")
            time.sleep(1)
    except IOError:
        print("\nNo recent export for Orders found."
              "\nReturning...")
        return

    with open(fn, 'r') as f:
        data = json.load(f)
        # print(json.dumps(data, indent=4, sort_keys=True))

        # Define a new list to contain collapsed dictionaries from source
        newDictStorage = []

        # Print data to be cleaned up
        for n in data['orders']:  # each element is a distinct customer
            newDict = {}
            for key in n:  # list of left hand keys
                if type(n[key]) is not dict and type(n[key]) is not list:  # valid folding
                    # print(type(n[key]), key, n[key])
                    newDict[key] = n[key]
                    # print(newDict[key])
            for key in n:
                if type(n[key]) is dict and key == 'customer':  # overwrite with dict values, usually the default addres object.
                    # print('Dictionary found! Folding...')
                    newDict['customer_id'] = n[key]['id']
                    newDict['customer_email'] = n[key]['email']
                    newDict['customer_created_at'] = n[key]['created_at']
                    newDict['customer_updated_at'] = n[key]['updated_at']
                    newDict['customer_first_name'] = n[key]['first_name']
                    newDict['customer_last_name'] = n[key]['last_name']
                    newDict['customer_orders_count'] = n[key]['orders_count']
                    newDict['customer_total_spent'] = n[key]['total_spent']
            newDictStorage.append(newDict)


        # print(newDictStorage)
        # print(json.dumps(newDictStorage, indent=4, sort_keys=True))


        # Cleanup data so that it can be read by a COPY command using auto
        if not admin:
            c = 'y'
        else:
            c = input("Write data? (y/n): ")
        if c == 'y':
            ofiledir = '/Users/kevinip/Documents/POST GRAD/PyCharm Projects/kevinip-sandbox/Tasks/Fanjoy Analysis/Queries/Shopify Extraction/orders-cleaned/'
            ofilename = (str(today.month) + '-' + str(today.day) + '-' + str(today.year) + 'jp_orders_cleaned.json')
            objCount = 0
            fn = ofiledir + ofilename
            os.makedirs(ofiledir, exist_ok=True)

            with open(fn, 'w') as f:
                for obj in newDictStorage:
                    json.dump(obj, f)
                    f.write('\n')
                    objCount += 1
            print("Write successful. {} objects written.".format(objCount))
        else: print("Returning...")


def cleanupLineItems(admin=False):
    """Cleanup orders.json and extract only line item data"""
    d = str(today.month) + '-' + str(today.day) + '-' + str(today.year)
    fn = d + 'jp_orders.json'
    print(fn)
    try:
        if (os.path.isfile(fn)):
            print("File found! Proceeding to cleanup...")
            time.sleep(1)
    except IOError:
        print("\nNo recent export for Orders found."
              "\nReturning...")
        return


    with open(fn, 'r') as f:
        data = json.load(f)
        # print(json.dumps(data, indent=4, sort_keys=True))

        # Define a new list to contain collapsed dictionaries from source
        newDictStorage = []

        # Print data to be cleaned up
        for n in data['orders']:  # each element is a distinct customer
            for key in n:
                if type(n[key]) is list and key == 'line_items':
                    for obj in n[key]: # obj is a dictionary
                        newDict = {}
                        newDict['order_number'] = n['order_number']
                        for k in obj: # k is the key inside each line item
                            if type(obj[k]) is not dict and type(obj[k]) is not list:
                                newDict[k] = obj[k]

                        # After every key in this specific line item has been processed, append to object
                        newDictStorage.append(newDict)

        # print(newDictStorage)
        # print(json.dumps(newDictStorage, indent=4, sort_keys=True))


        # Cleanup data so that it can be read by a COPY command using auto
        if not admin:
            c = 'y'
        else:
            c = input("Write data? (y/n): ")
        if c == 'y':
            ofiledir = '/Users/kevinip/Documents/POST GRAD/PyCharm Projects/kevinip-sandbox/Tasks/Fanjoy Analysis/Queries/Shopify Extraction/lineitems-cleaned/'
            ofilename = (str(today.month) + '-' + str(today.day) + '-' + str(today.year) + 'jp_lineitems_cleaned.json')
            objCount = 0
            os.makedirs(ofiledir, exist_ok=True)
            fn = ofiledir + ofilename
            with open(fn, 'w') as f:
                for obj in newDictStorage:
                    json.dump(obj, f)
                    f.write('\n')
                    objCount += 1
            print("Write successful. {} objects written.".format(objCount))
        else: print("Returning...")


def cleanupProducts(admin=False):
    """Cleanup products.json"""
    d = str(today.month) + '-' + str(today.day) + '-' + str(today.year)
    fn = d + 'jp_products.json'
    print(fn)
    try:
        if (os.path.isfile(fn)):
            print("File found! Proceeding to cleanup...")
            time.sleep(1)
    except IOError:
        print("\nNo recent export for Products found."
              "\nReturning...")
        return


    with open(fn, 'r') as f:
        data = json.load(f)
        # print(json.dumps(data, indent=4, sort_keys=True))

        # Define a new list to contain collapsed dictionaries from source
        newDictStorage = []

        # Print data to be cleaned up
        for n in data['products']:  # each element is a distinct customer
            for key in n:
                if type(n[key]) is list and key == 'variants':  # overwrite with dict values, usually the default addres object.
                    # print('Dictionary found! Folding...')
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


        # print(newDictStorage)
        # print(json.dumps(newDictStorage, indent=4, sort_keys=True))


        # Cleanup data so that it can be read by a COPY command using auto
        if not admin:
            c = 'y'
        else:
            c = input("Write data? (y/n): ")
        if c == 'y':
            ofiledir = '/Users/kevinip/Documents/POST GRAD/PyCharm Projects/kevinip-sandbox/Tasks/Fanjoy Analysis/Queries/Shopify Extraction/products-cleaned/'
            ofilename = (str(today.month) + '-' + str(today.day) + '-' + str(today.year) + 'jp_products_cleaned.json')
            objCount = 0
            fn = ofiledir + ofilename
            os.makedirs(ofiledir, exist_ok=True)
            with open(fn, 'w') as f:
                for obj in newDictStorage:
                    json.dump(obj, f)
                    f.write('\n')
                    objCount += 1
            print("Write successful. {} objects written.".format(objCount))
        else: print("Returning...")


def main(choices=None, admin=False):
    if admin:
        cleanupCustomers()
        cleanupOrders()
        cleanupProducts()
        cleanupLineItems()
        print("\nAll nodes have been reformatted properly for Redshift. Returning...")
        if choices:
            choices.remove(2)
        time.sleep(1)
        return ()
    else:
        while True:
            c = input("\nChoose an option (q to quit):"
                      "\n1. EXPORT ALL"
                      "\n2. Customers"
                      "\n3. Orders"
                      "\n4. Products"
                      "\n5. Line items\n")
            if c == 'q':
                print("\nExiting...")
                time.sleep(1)
                quit()
            elif c == '1':
                cleanupCustomers()
                cleanupOrders()
                cleanupProducts()
                cleanupLineItems()
                print("\nAll nodes have been reformatted properly for Redshift. Returning...")
                if choices:
                    choices.remove(2)
                time.sleep(1)
                return()
            elif c == '2': cleanupCustomers()
            elif c == '3': cleanupOrders()
            elif c == '4': cleanupProducts()
            elif c == '5': cleanupLineItems()
            else: print("Invalid input.")


if __name__ == '__main__':
    print(os.getcwd())
    main()