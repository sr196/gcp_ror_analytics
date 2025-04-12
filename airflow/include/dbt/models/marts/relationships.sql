{{
  config(
    materialized='table',
    unique_key='relationship_id'
  )
}}

select
  r.id as relationship_id,
  e.id as entity_id,
  r.label,
  r.type
from {{ source('staging', 'sample_data') }} e,
unnest(e.relationships) r
