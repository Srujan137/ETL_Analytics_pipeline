{{ config(materialized='table') }}

with src as (select * from {{ ref('stg_usage_events') }})

select distinct
    impact_loc                as location_name,
    /* choose a deterministic key for BI joins */
    md5(coalesce(impact_loc,'')) as location_id,
    /* keep coords if present for mapping */
    avg(xpos) over (partition by impact_loc) as avg_xpos,
    avg(ypos) over (partition by impact_loc) as avg_ypos
from src
where impact_loc is not null
