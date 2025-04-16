-- models/core/active_entities.sql
{{
  config(
    materialized='incremental',
    incremental_strategy='insert_overwrite',
    partition_by={'field': 'last_modified_date', 'data_type': 'date'},
    description='Incrementally updated active entities'
  )
}}

select *
from {{ ref('entity_overview') }}
where status = 'active'

{% if is_incremental() %}
  and last_modified_date > _dbt_max_partition
{% endif %}
