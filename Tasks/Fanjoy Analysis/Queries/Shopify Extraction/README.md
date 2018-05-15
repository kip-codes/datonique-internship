# Extracting Data from Shopify Storefront API

This extraction process will pull the most important data from the Shopify API, particularly from the nodes of Customers, Orders, and Products.

## Getting Started

Simply run *jp_extract.py* and follow the instructions to extract specific or all nodes.
If a connection cannot be established to the storefront API, the script will end.

### Prerequisites

*jp_extract.py* will require:

```
1. The name of the store,
2. The administrator password associated with the store,
3. A valid API key for Storefront API extraction.
```

*jp_extract.py* depends on two other scripts, containing function definitions:

* *jp_extract_function.py*, containing basic functions for extraction
* *jp_extract_cleanup.py*, which cleans up the JSON to fit the Amazon Redshift COPY command format.


## Deployment

*jp_extract.py* will create temporary .json files in the same directory it is stored in.
It will also create a subdirectory and store cleaned .json files there, if one does not already exist.

Run *jp_extract.py* with two (2) parameters:
```
1. Shopify Credentials, each on a single line
    * Storefront name
    * Password to the admin account for this store
    * API Key
2. AWS Credentials, each on a single line
    * AWS Access Key
    * AWS Secret Access Key
```
Otherwise, running without parameters will take the user through interactive menus and output will be more verbose.

Alternatively, run *jp_extract_cleanup.py* if you already have .json from Shopify and you only need to fold it.

## Authors

* **Kevin Ip** - *Initial work* - [kip-codes](https://github.com/kip-codes)
