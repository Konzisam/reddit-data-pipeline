### Spin up the services
`docker-compose up -d --build`

in airflow run the pipeline to write data to local and s3 , from which we will run glue crawler to determine the data schema and create metadata rables in catalog.\
In Athena we use this to query the data directly from S3 but also to load it to redshift for anlytics purposes.\
Lastly we connect quicksight to redshift to visualize the data

