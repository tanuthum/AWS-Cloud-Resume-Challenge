import json
import boto3
from decimal import Decimal

dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table('ViewCount')

def lambda_handler(event, context):
    try:
        method = event.get("httpMethod") or event.get("requestContext", {}).get("http", {}).get("method")
        if method != "GET":
            return {
                'statusCode': 405,
                'body': json.dumps({'error': 'Method not allowed'})
            }

        response = table.update_item(
            Key={'id': 'views'},
            UpdateExpression='ADD #v :inc',
            ExpressionAttributeNames={'#v': 'views'},
            ExpressionAttributeValues={':inc': 1},
            ReturnValues='UPDATED_NEW'
        )

        views = response['Attributes']['views']
        return {
            'statusCode': 200,
            'headers': { 'Access-Control-Allow-Origin': '*' },
            'body': json.dumps({'views': int(views) if isinstance(views, Decimal) else views})
        }

    except Exception as e:
        return {
            'statusCode': 500,
            'body': json.dumps({'error': str(e)})
        }

