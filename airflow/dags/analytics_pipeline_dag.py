from airflow import DAG
from airflow.operators.python import PythonOperator
from airflow.operators.bash import BashOperator
from datetime import datetime
 

# Paths
DBT_PROJECT_DIR = "/usr/local/airflow/impact_analytics"   # container path (adjust if running locally)
DBT_PROFILES_DIR = "/usr/local/airflow"                   # airflow home contains profiles.yml

default_args = {
    'owner': 'airflow',
    'depends_on_past': False,
    'retries': 1,
}

with DAG(
    dag_id='analytics_pipeline',
    default_args=default_args,
    description='ETL + dbt pipeline',
    schedule='@hourly',
    start_date=datetime(2025, 1, 1),
    catchup=False,
    tags=['analytics', 'snowflake', 'dbt'],
) as dag:

    
    # Task 2: Run dbt models
    run_dbt_models = BashOperator(
        task_id='run_dbt_models',
        bash_command=f"dbt run --profiles-dir {DBT_PROFILES_DIR} --project-dir {DBT_PROJECT_DIR}"
    )


    # Define task dependencies
run_dbt_models 