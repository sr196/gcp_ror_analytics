-- models/relationships/relationship_network.sql
{{
  config(
    materialized='view',
    cluster_by=['source_id'],
    description='Entity relationship graph structure'
  )
}}

select
  e.id as source_id,
  r.relationship_id as target_id,
  r.type as relationship_type,
  r.label as relationship_label
from {{ ref('base_entity') }} e
join {{ ref('relationships') }} r on e.id = r.entity_id
where e.status = 'active'
