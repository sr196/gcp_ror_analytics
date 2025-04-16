from airflow.decorators import dag, task
from datetime import datetime
from include.dbt.cosmos_config import DBT_PROJECT_CONFIG, DBT_CONFIG
from cosmos.airflow.task_group import DbtTaskGroup
from cosmos.constants import LoadMode
from cosmos.config import RenderConfig

@dag(
    start_date=datetime(2025, 1, 1),
    schedule=None,
    catchup=False,
    tags=['analytics'],
)
def run_analytics_dbt_models():

    dimentional_models = DbtTaskGroup(
            group_id='dimentional_models',
            project_config=DBT_PROJECT_CONFIG,
            profile_config=DBT_CONFIG,
            render_config=RenderConfig(
                load_method=LoadMode.DBT_LS,
                select=['path:models/marts']
            )
        )
    
    analytical_models = DbtTaskGroup(
            group_id='analytical_models',
            project_config=DBT_PROJECT_CONFIG,
            profile_config=DBT_CONFIG,
            render_config=RenderConfig(
                load_method=LoadMode.DBT_LS,
                select=['path:models/analytical_views']
            )
        )

    dimentional_models >> analytical_models
    
run_analytics_dbt_models()