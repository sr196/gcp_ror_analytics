{{
  config(
    materialized='table',
    unique_key='external_id'
  )
}}

select
  e.id as entity_id,
  ei.preferred as preferred_id,
  ei.type as id_type
from {{ source('staging', 'sample_data') }} e,
unnest(e.external_ids) ei
