## End to end data Pipeline with reddit API

The Reddit data pipeline orchestrates the process of fetching, storing, and processing data from Reddit, storing it in a data lake for easy access. 
The pipeline automates schema discovery, enabling efficient querying and analysis of the raw data. It then transforms and loads the data into a data warehouse for deeper analysis.
Finally, the processed data is visualized to provide interactive insights through dynamic dashboards.\
This pipeline demonstrates efficient data processing, querying, and visualization of a typical data pipeline.


### Key Features:
* **Data Orchestration:** Apache Airflow to orchestrate fetching data from Reddit, saving it to Amazon S3, and automate the process triggering subsequent transformation and loading jobs.

* **Airflow database:** Amazon RDS for PostgreSQL to host the Airflow metadata database, for Airflow to store  state, logs, and task history.
* **Airflow server:** EC2 to host Apache Airflow 
* **AWS Glue Crawlers** AWS Glue Crawlers to automatically discover the schema of the raw data stored in Amazon S3 and create a data catalog in the AWS Glue Data Catalog.
* **Data Preview:** Amazon Athena to perform SQL queries directly on the data stored in Amazon S3 , for quick analysis and validation before transformation

* **S3:** Amazon S3, serving as the data lake for the project,as well as backend for terraform state.

* **Data Catalog:** AWS Glue Data Catalog to maintain a metadata catalog of the data schema, enabling easy reference during ETL operations and for querying through Amazon Athena and Redshift.

* **Amazon Redshifz:** The transformed data was loaded into Redshift, enabling  querying and connecting to visualization tools.

* **AWS Glue:** Triggered Glue jobs through AWS Lambda in response to specific events, enabling serverless ETL processing based on the data changes or schedules.

* **Data Visualization:** Amazon QuickSight for interactive data visualizations and creating dashboards based on data stored in Amazon Redshift.

* **CI/CD for Infrastructure:** GitHub Actions for  (CI/CD) workflows, automating the deployment of aiflow to ec2 and infrastructure changes.

* **Infrastructure as Code (IaC):** Automated the provisioning of cloud resources using Terraform, for consistent deployments .

* **Glue job Trigger:** Lambda to trigger AWS Glue jobs, allowing for a seamless, event-driven workflow where transformation happens when new data lands in s3.

* **IAM for Access Control:** IAM roles and policies to manage secure access to the resources.

* **Terraform:** Automate the provisioning nad ensure consitency of deployment of cloud infrastracture(IaC)

* **Github Actions:** Automation CI/CD processes, enabling consistent execution of the etl code and infrastructure.
