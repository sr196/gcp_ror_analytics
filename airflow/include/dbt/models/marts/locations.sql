{{
  config(
    materialized='table',
    unique_key='geonames_id'
  )
}}

select
  l.geonames_id,
  e.id as entity_id,
  g.name as location_name,
  g.lng as longitude,
  g.lat as latitude,
  g.country_subdivision_name,
  g.country_subdivision_code,
  g.country_name,
  g.country_code,
  g.continent_name,
  g.continent_code
from {{ source('staging', 'sample_data') }} e,
unnest(e.locations) l,
unnest([l.geonames_details]) g
