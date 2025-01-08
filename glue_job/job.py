import sys
import boto3
from awsglue.transforms import *
from awsglue.utils import getResolvedOptions
from pyspark.context import SparkContext
from awsglue.context import GlueContext
from awsglue.job import Job
from pyspark.sql.functions import concat_ws, to_date
from awsglue import DynamicFrame

def get_ssm_parameter(name, with_decryption=False):
    ssm = boto3.client('ssm')
    response = ssm.get_parameter(Name=name, WithDecryption=with_decryption
    )
    return response['Parameter']['Value']

s3_bucket = get_ssm_parameter("/redshift/s3_bucket")
password = get_ssm_parameter("/redshift/password", True)
connection_url = get_ssm_parameter("/redshift/connection_url")
account_id = get_ssm_parameter("/redshift/account_id")
redshift_connection_name = get_ssm_parameter("/redshift/glue_redshift_connection")

args = getResolvedOptions(sys.argv, ['JOB_NAME'])

database_name = "reddit_db"
table_name = "raw"
redshift_connection_name = "glue-redshift-connection"

sc = SparkContext()
glueContext = GlueContext(sc)
spark = glueContext.spark_session
job = Job(glueContext)

job.init(args['JOB_NAME'], args)


input_dynamic_frame = glueContext.create_dynamic_frame.from_catalog(
    database=database_name,
    table_name=table_name,
    transformation_ctx="input_dynamic_frame"
)

df = input_dynamic_frame.toDF()
print(df.head())

df_combined = df.withColumn(
    'ESS_updated',
    concat_ws('-', df['edited'], df['spoiler'], df['stickied'])
).drop('edited', 'spoiler', 'stickied')

output_dynamic_frame = DynamicFrame.fromDF(df_combined, glueContext, 'output_dynamic_frame')


glueContext.write_dynamic_frame.from_jdbc_conf(
    frame=output_dynamic_frame,
    catalog_connection=redshift_connection_name,
    connection_options={
        "database": "dev",
        # "url": f"{connection_url}",
        "dbtable": "reddit_de",
        # "user": "admin",
        # "password": f"{password}",

        "aws_iam_role": f"arn:aws:iam::{account_id}:role/service-role/AWSGlueServiceRole-reddit_glue"
    },
    redshift_tmp_dir=f"s3://{s3_bucket}/redshift-temp/",
    transformation_ctx="output_dynamic_frame"
)

job.commit()