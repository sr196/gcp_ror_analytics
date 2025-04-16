-- models/locations/geospatial_analysis.sql
{{
  config(
    materialized='materialized_view',
    partition_by={
      'field': 'geonames_details.country_code',
      'data_type': 'string'
    },
    cluster_by=['continent_code'],
    full_refresh = true,
    description='Optimized geospatial query layer'
  )
}}

select
  e.id,
  l.*
from {{ ref('base_entity') }} e
join {{ ref('locations') }} l on e.id = l.entity_id
where l.latitude is not null
