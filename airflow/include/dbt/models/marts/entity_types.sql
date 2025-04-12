{{
  config(
    materialized='table'
  )
}}

select
  e.id as entity_id,
  type_value
from {{ source('staging', 'sample_data') }} e,
unnest(e.types) type_value
