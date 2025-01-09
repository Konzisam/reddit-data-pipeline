# End to end data Pipeline with reddit API

* The Reddit data pipeline uses Apache Airflow, hosted on an Amazon EC2 instance, to orchestrate data fetching from Reddit and store it in Amazon S3.
* AWS Glue Crawlers automatically discover the schema of the raw data in S3 and create a catalog in the AWS Glue Data Catalog.
* Amazon Athena is used for serverless SQL querying of the raw data in S3, allowing for quick analysis and validation. 
* The raw data is then transformed using AWS Glue based on the discovered schema, and the transformed data is loaded into Amazon Redshift for analysis. 
* Finally, the processed data is visualized with Amazon QuickSight, providing interactive dashboards and insights. 
* This pipeline demonstrates efficient data processing, querying, and visualization of a typical data pipeline.


### Key Features:
* **Data Orchestration:** Apache Airflow to orchestrate fetching data from Reddit, saving it to Amazon S3, and automate the process triggering subsequent transformation and loading jobs.

* **Airflow database:** Amazon RDS for PostgreSQL to host the Airflow metadata database, for Airflow to store  state, logs, and task history.
* **Airflow server:** EC2 to host Apache Airflow 
* **Data Discovery:** AWS Glue Crawlers to automatically discover the schema of the raw data stored in Amazon S3 and create a data catalog in the AWS Glue Data Catalog.

* **Data Transformation:** AWS Glue was employed to clean, transform, and process the raw Reddit data, utilizing the catalog schema created by the Glue Crawler. The transformed data was loaded into Amazon Redshift for querying.

* **Data Preview:** Amazon Athena to perform SQL queries directly on the data stored in Amazon S3 , for quick analysis and validation before transformation

* **S3 Datalake:** Amazon S3, serving as the data lake for the project,as well as backend for terraform state.

* **Data Catalog:** AWS Glue Data Catalog to maintain a metadata catalog of the data schema, enabling easy reference during ETL operations and for querying through Amazon Athena and Redshift.

* **Data Warehouse:** The transformed data was loaded into Amazon Redshift serverless, enabling  querying and conecting to visualization tools.

* **Serverless Transformation:** Triggered AWS Glue jobs through AWS Lambda in response to specific events, enabling serverless ETL processing based on the data changes or schedules.

* **Data Visualization:** Amazon QuickSight for interactive data visualizations and creating dashboards based on data stored in Amazon Redshift.

* **CI/CD for Infrastructure:** GitHub Actions for  (CI/CD) workflows, automating the deployment of aiflow to ec2 and infrastructure changes.

* **Infrastructure as Code (IaC):** Automated the provisioning of cloud resources using Terraform, for consistent deployments .

* **Glue job Trigger:** Lambda to trigger AWS Glue jobs, allowing for a seamless, event-driven workflow where transformation happens when new data lands in s3.

* **IAM for Access Control:** IAM roles and policies to manage secure access to the resources.

### Spin up the services
`docker-compose up -d --build`

` docker compose up airflow-init`
`docker-compose --env-file ./airflow.env up -d --build`
in airflow run the pipeline to write data to local and s3 , from which we will run glue crawler to determine the data schema and create metadata rables in catalog.\
In Athena we use this to query the data directly from S3 but also to load it to redshift for anlytics purposes.\
Lastly we connect quicksight to redshift to visualize the data