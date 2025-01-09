### Project replication instructions
1. 
`docker-compose up -d --build`

Airflow init
` docker compose up airflow-init`
RUn the rest of the services, passing the environment variables.
`docker-compose --env-file ./airflow.env up -d --build`
