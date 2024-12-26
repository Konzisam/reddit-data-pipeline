import sys

from awsglue.transforms import *
from awsglue.utils import getResolvedOptions
from pyspark.context import SparkContext
from awsglue.context import GlueContext
from awsglue.job import Job
from pyspark.sql.functions import concat_ws
from awsglue import DynamicFrame
from datetime import datetime

args = getResolvedOptions(sys.argv, ['JOB_NAME', 'S3_BUCKET'])
s3_bucket = args['S3_BUCKET']
sc = SparkContext()
glueContext = GlueContext(sc)
spark = glueContext.spark_session
job = Job(glueContext)
job.init(args['JOB_NAME'], args)

today = datetime.now().strftime('%Y%m%d')

input_path = f"s3://{s3_bucket}/raw/{today}.csv"
output_path = f"s3://{s3_bucket}/transformed_latest/"

input_dynamic_frame = glueContext.create_dynamic_frame.from_options(
    format_options={"quoteChar": "\"", "withHeader": True, "separator": ","},
    connection_type="s3", format="csv",
    connection_options={"paths": [input_path], "recurse": True},
    transformation_ctx="input_dynamic_frame")

df = input_dynamic_frame.toDF()

# concatenate the three columns into a single columns
df_combined = df.withColumn('ESS_updated', concat_ws('-', df['edited'], df['spoiler'], df['stickied']))
df_combined = df_combined.drop('edited', 'spoiler', 'stickied')

# convert back to DynamicFrame
output_dynamic_frame = DynamicFrame.fromDF(df_combined, glueContext, 'output_dynamic_frame')

glueContext.write_dynamic_frame.from_options(
    frame=output_dynamic_frame,
    connection_type="s3",
    format="csv",
    connection_options={"path": output_path, "partitionKeys": []},
    transformation_ctx="output_dynamic_frame"
)

job.commit()