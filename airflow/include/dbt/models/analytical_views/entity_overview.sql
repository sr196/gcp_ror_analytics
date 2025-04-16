-- models/core/entity_overview.sql
{{
  config(
    materialized='view',
    description='Core entity overview with names, types, and locations'
  )
}}

with entities as (
  select
    e.id,
    e.status,
    e.established,
    any_value(created_date) as created_date,
    any_value(last_modified_date) as last_modified_date
  from {{ ref('base_entity') }} e
  group by 1,2,3
),

names as (
  select 
    entity_id,
    name_value as primary_name
  from {{ ref('names') }}
  WHERE name_type like "%display%"
)

select
  e.*,
  n.primary_name,
  array_agg(distinct t.type_value) as entity_types,
  array_agg(distinct l.country_name) as countries
from entities e
left join names n on e.id = n.entity_id
left join {{ ref('entity_types') }} t on e.id = t.entity_id
left join {{ ref('locations') }} l on e.id = l.entity_id
group by 1,2,3,4,5,6
