import json
import os
import uuid

import boto3
from flatten_dict import flatten
from utils import extract_product_id

dynamodb = boto3.resource("dynamodb")
table = dynamodb.Table(os.getenv("TABLE_NAME"))


def lambda_handler(event, context):
    for record in event['Records']:
        body: dict = json.loads(record['body'])
        data = flatten(body, reducer="underscore")
        product_name = data.get("issue_projects")
        product_id = extract_product_id(product_name)
        data.setdefault('UserId', str(uuid.uuid4()))
        data.setdefault('product_id', product_id)
        table.put_item(Item=data)
