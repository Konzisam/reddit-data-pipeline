FROM apache/airflow:2.7.1-python3.9

COPY requirements.txt /opt/airflow/

USER root
RUN mkdir -p /opt/airflow/logs && chmod -R 777 /opt/airflow/logs
RUN apt-get update && apt-get install -y gcc python3-dev

USER airflow

RUN pip install --no-cache-dir -r /opt/airflow/requirements.txt