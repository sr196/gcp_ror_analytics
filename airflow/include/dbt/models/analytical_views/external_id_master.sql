-- models/identifiers/external_id_master.sql
{{
  config(
    materialized='view',
    grant_access_to=[
      {'project': 'leafy-loader-456407-i6', 'dataset': 'transformed'}
    ],
    description='Authorized view for external ID mapping'
  )
}}

select
  e.id as internal_id,
  x.id_type as id_type,
  x.preferred_id as external_id
from {{ ref('base_entity') }} e
join {{ ref('external_ids') }} x on e.id = x.entity_id
