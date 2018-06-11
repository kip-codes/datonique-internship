# File: klf_cma
# Project: kevinip-sandbox
# Local author: kevinip
# Created on 06/05/2018 at 10:40 AM
#
# For inquiries about the file please contact the author.


import base64
import boto3
import calendar
from datetime import datetime, timedelta
from dateutil import parser
import io
import json
import os
import psycopg2
import requests
import sys
import time

base_url = 'https://api.infusionsoft.com/crm/rest/v1'

today = datetime.today().date()
yesterday = datetime.today().date() - timedelta(days = 1)

schema = 'klf'
bucket = 'klf-datonique' #could switch to parameter or environment variable in Lambda
key_stem = 'InfusionSoft/'

mybucket = 'kevin-ip-datonique'
mykey_stem = 'klf/users'


def jsonString(json_collection):
	with io.StringIO() as f:
		for entry in json_collection:
			f.write("%s\n" % json.dumps(entry))
		return f.getvalue()

def s3_write(output, bucket, key):
	s3 = boto3.resource('s3')
	s3.Object(bucket, key).put(
	    Body=output)

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
	if delete:
		cur.execute(delete)
	cur.execute(copy)
	db.commit()
	cur.close()
	db.close()


def acquireToken():
	key = '{}infusionSoftTokens'.format(key_stem)
	access_token, refresh_token = s3_read(key)
	return access_token
