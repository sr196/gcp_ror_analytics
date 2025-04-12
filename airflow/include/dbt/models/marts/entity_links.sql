{{
  config(
    materialized='table'
  )
}}

select
  e.id as entity_id,
  l.value as link_value,
  l.type as link_type
from {{ source('staging', 'sample_data') }} e,
unnest(e.links) l
