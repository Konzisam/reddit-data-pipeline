import boto3
import json

def lambda_handler(event, context):
    print("Received event:", json.dumps(event, indent=4))

    glue_client = boto3.client('glue', region_name="eu-central-1")

    for record in event['Records']:
        s3_bucket = record['s3']['bucket']['name']
        s3_key = record['s3']['object']['key']
        if s3_key.startswith('raw/'):
            response = glue_client.start_job_run(JobName="reddit_job_latest")
            print(f"Triggered Glue job: {response['JobRunId']}")