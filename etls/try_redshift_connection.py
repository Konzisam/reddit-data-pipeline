import boto3

def run_glue_job(job_name):
    glue_client = boto3.client('glue', region_name='eu-central-1')

    response = glue_client.start_job_run(JobName=job_name)
    job_run_id = response['JobRunId']
    print(f"Job started successfully. JobRunId: {job_run_id}")
    return job_run_id

def check_job_status(job_name, job_run_id):
    glue_client = boto3.client('glue', region_name='eu-central-1')


    response = glue_client.get_job_run(JobName=job_name, RunId=job_run_id)
    status = response['JobRun']['JobRunState']
    print(f"Job run status: {status}")
    return status

def main():
    job_name = "reddit_job_latest"


    job_run_id = run_glue_job(job_name)


    status = check_job_status(job_name, job_run_id)
    print(f"Final job status: {status}")

if __name__ == "__main__":
    main()


# import boto3
# import psycopg2
#
def get_ssm_parameter(name):
    ssm = boto3.client('ssm')
    response = ssm.get_parameter(
        Name=name,
        WithDecryption=True  # Decrypts the parameter if it's a SecureString
    )
    return response['Parameter']['Value']
#
# def main():
#     # Get Redshift credentials from SSM
#     redshift_username = "admin"
#     redshift_password = get_ssm_parameter("/redshift/password")
#      url =get_ssm_parameter("/redshift/url")
#     redshift_host = ur
#     redshift_port = 5439
#     redshift_db = "dev"
#
#     # Connect to Redshift using psycopg2
#     conn = psycopg2.connect(
#         dbname=redshift_db,
#         user=redshift_username,
#         password=redshift_password,
#         host=redshift_host,
#         port=redshift_port
#     )
#     # Your Redshift interaction logic
#     cursor = conn.cursor()
#     cursor.execute("SELECT * FROM reddit_de limit 2;")
#     rows = cursor.fetchall()
#     print(rows)
#
#     # Close the connection
#     cursor.close()
#     conn.close()
#
# if __name__ == "__main__":
#     main()