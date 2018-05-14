# File: jp_extract_functions
# Project: kevinip-sandbox
# Local author: kevinip
# Created on 05/07/2018 at 1:24 PM
#
# For inquiries about the file please contact the author.


class txt:
    """Allow text formatting for terminal output."""
    PURPLE = '\033[95m'
    CYAN = '\033[96m'
    DARKCYAN = '\033[36m'
    BLUE = '\033[94m'
    GREEN = '\033[92m'
    YELLOW = '\033[93m'
    RED = '\033[91m'
    BOLD = '\033[1m'
    UNDERLINE = '\033[4m'
    END = '\033[0m'

def strike(text):
    result = ''
    for c in text:
        result = result + c + '\u0336'
    return result


def takeCredentials():
    """"Obtain the URL needed to access the JSON."""
    while True:
        storeurl = input("Please enter the store page you are trying to access:\t")
        print(txt.UNDERLINE + "Your current string is:\n" + txt.END + storeurl + '\n')

        pw = input("Enter your password for this store:\t")
        print(txt.UNDERLINE + "Your current string is:\n" + txt.END + '<api_key>:' + pw + '@' + storeurl + '\n')

        api_key = input("Enter the API key for this page:\t")
        print(txt.UNDERLINE + "Your current string is:\n" + txt.END + api_key + ':' + pw + '@' + storeurl + '\n')

        print(txt.UNDERLINE + "Your current string is:\n" + txt.END + 'https://' + api_key + ':' + pw + '@' + storeurl + '.myshopify.com/admin/<node-type>.json\n')
        print("If you would like to revise the URL, enter " + txt.BOLD + 'retry.' + txt.END)

        while True:
            q = input("If you are satisfied with this URL, enter " + txt.BOLD + 'done' + txt.END + ":\t")
            if q == 'done':
                return {'storeurl':storeurl, 'pw':pw, 'api_key':api_key}
                # return 'https://' + api_key + ':' + pw + '@' + storeurl + '.myshopify.com/admin/' + nodetype + '.json'
            else:
                print("Invalid value. Please enter 'retry' or 'done'.")

def takeNode(nodes):
    while True:
        print("\nEnter which of the following nodes you would like to access:")
        if 'customers' in nodes:
            print("1. Customers")
        else: # customers has been exported already
            print(strike("1. Customers"))
        if 'orders' in nodes:
            print("2. Orders")
        else: # orders has been exported already
            print(strike("2. Orders"))
        if 'products' in nodes:
            print("3. Products")
        else: # products has been exported already
            print(strike("3. Products"))

        nodetype = input('\n')
        # Convert nodetype to string
        if nodetype in ('1', 'customers'):
            return 'customers'
        elif nodetype in ('2', 'orders'):
            return 'orders'
        elif nodetype in ('3', 'products'):
            return 'products'
        else:
            print("Invalid node type. Please enter the numerical value of the categories above.")


def makeURL(creds, nodetype):
    return 'https://' + creds['storeurl'] + '.myshopify.com/admin/' + nodetype + '.json'