{{
  config(
    materialized='table',
    unique_key='id'
  )
}}

select
  id,
  status,
  established,
  admin.last_modified.schema_version as last_modified_schema_version,
  admin.last_modified.date as last_modified_date,
  admin.created.schema_version as created_schema_version,
  admin.created.date as created_date
from {{ source('staging', 'sample_data') }}
