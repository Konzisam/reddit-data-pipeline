import configparser
import os
from dotenv import load_dotenv

load_dotenv()

parser = configparser.ConfigParser()
# parser.read(os.path.join(os.path.dirname(__file__), '../config/config.conf'))

parser.set('api_keys', 'reddit_secret_key', os.getenv('REDDIT_SECRET_KEY', parser.get('api_keys', 'reddit_secret_key')))
parser.set('api_keys', 'reddit_client_id', os.getenv('REDDIT_CLIENT_ID', parser.get('api_keys', 'reddit_client_id')))

parser.set('aws', 'aws_access_key_id', os.getenv('AWS_ACCESS_KEY_ID', parser.get('aws', 'aws_access_key_id')))
parser.set('aws', 'aws_secret_access_key', os.getenv('AWS_SECRET_ACCESS_KEY', parser.get('aws', 'aws_secret_access_key')))
parser.set('aws', 'aws_region', os.getenv('AWS_REGION', parser.get('aws', 'aws_region')))
parser.set('aws', 'aws_bucket_name', os.getenv('AWS_BUCKET_NAME', parser.get('aws', 'aws_bucket_name')))


# Now you can use the updated configuration as normal
SECRET = parser.get('api_keys', 'reddit_secret_key')
CLIENT_ID = parser.get('api_keys', 'reddit_client_id')


# AWS Configuration
AWS_ACCESS_KEY_ID = parser.get('aws', 'aws_access_key_id')
AWS_SECRET_ACCESS_KEY = parser.get('aws', 'aws_secret_access_key')
AWS_REGION = parser.get('aws', 'aws_region')
AWS_BUCKET_NAME = parser.get('aws', 'aws_bucket_name')

INPUT_PATH = parser.get('file_paths', 'input_path', fallback='/opt/airflow/data/input')
OUTPUT_PATH = parser.get('file_paths', 'output_path', fallback='/opt/airflow/data/output')

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