import configparser
import os

parser = configparser.ConfigParser()
parser.read(os.path.join(os.path.dirname(__file__), '../config/config.conf'))

SECRET = parser.get('api_keys', 'reddit_secret_key')
CLIENT_ID = parser.get('api_keys', 'reddit_client_id')

# DATABASE_HOST =  parser.get('database', 'database_host')
# DATABASE_NAME =  parser.get('database', 'database_name')
# DATABASE_PORT =  parser.get('database', 'database_port')
# DATABASE_USER =  parser.get('database', 'database_username')
# DATABASE_PASSWORD =  parser.get('database', 'database_password')

#AWS
AWS_ACCESS_KEY_ID = parser.get('aws', 'aws_access_key_id')
AWS_SECRET_ACCESS_KEY = parser.get('aws', 'aws_secret_access_key')
AWS_REGION = parser.get('aws', 'aws_region')
AWS_BUCKET_NAME = parser.get('aws', 'aws_bucket_name')

INPUT_PATH = parser.get('file_paths', 'input_path')
OUTPUT_PATH = parser.get('file_paths', 'output_path')

POST_FIELDS = (
    'id',
    'title',
    'score',
    'num_comments',
    'author',
    'created_utc',
    'url',
    'over_18',
    'edited',
    'spoiler',
    'stickied'
)

# import configparser
# import os
# from dotenv import load_dotenv
#
# load_dotenv()
#
# parser = configparser.ConfigParser()
#
#
# SECRET = os.getenv('REDDIT_SECRET_KEY', 'default_secret_key')
# CLIENT_ID = os.getenv('REDDIT_CLIENT_ID', 'default_client_id')
# AWS_ACCESS_KEY_ID = os.getenv('AWS_ACCESS_KEY_ID', 'default_access_key')
# AWS_SECRET_ACCESS_KEY = os.getenv('AWS_SECRET_ACCESS_KEY', 'default_secret_key')
# AWS_REGION = os.getenv('AWS_REGION', 'default_region')
# AWS_BUCKET_NAME = os.getenv('AWS_BUCKET_NAME', 'default_bucket_name')
#
# INPUT_PATH = os.getenv('INPUT_PATH', '/opt/airflow/data/input')
# OUTPUT_PATH = os.getenv('OUTPUT_PATH', '/opt/airflow/data/output')
#
# POST_FIELDS = (
#     'id',
#     'title',
#     'score',
#     'num_comments',
#     'author',
#     'created_utc',
#     'url',
#     'over_18',
#     'edited',
#     'spoiler',
#     'stickied'
# )

