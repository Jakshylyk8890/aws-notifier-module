import os

import boto3
from auth import authenticate
from product import fetch_all_products, fetch_product_details

instance = os.getenv("INSTANCE")
username = os.getenv("USERNAME")
password = os.getenv("PASSWORD")
client_id = os.getenv("CLIENT_ID")
client_secret = os.getenv("CLIENT_SECRET")
servicenow_table_name = os.getenv("SERVICENOW_TABLE_NAME")
dynamodb_table_name = os.getenv("DYNAMODB_TABLE_NAME")

dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table(dynamodb_table_name)


def lambda_handler(event, context):
    access_token, refresh_token = authenticate(
        instance, username, password, client_id, client_secret)
    products = fetch_all_products(
        instance, access_token)
    for product in products:
        print(product.get("name"), product.get("number"))
