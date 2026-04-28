{{ config(materialized='table') }}

with impacts as (select * from {{ ref('fct_impacts') }}),
loc as (select * from {{ ref('dim_location') }}),
sev_map as (select * from {{ ref('severity_mapping') }})

select
    i.location_id,
    l.location_name,
    count(*)                                 as total_impacts,
    count_if(sm.severity_level = 'High')     as high_severity_impacts,
    avg(i.max_g_impact)                      as avg_g_force,
    avg(l.avg_xpos)                          as approx_xpos,
    avg(l.avg_ypos)                          as approx_ypos
from impacts i
left join loc l
  on i.location_id = l.location_id
left join sev_map sm
  on i.severity_code = sm.severity_code
group by i.location_id, l.location_name
