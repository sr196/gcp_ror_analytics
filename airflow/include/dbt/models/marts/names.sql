{{
  config(
    materialized='table',
    unique_key='name_id'
  )
}}

select
  e.id as entity_id,
  n.lang,
  n.value as name_value,
  nt as name_type
from {{ source('staging', 'sample_data') }} e
LEFT JOIN unnest(e.names) n
LEFT JOIN UNNEST(n.types) nt
