{{ config(materialized='table') }}

with impacts as (select * from {{ ref('fct_impacts') }}),
sev_map as (select * from {{ ref('severity_mapping') }})

select
    shift_id,
    date_key,
    count(*)                                   as total_impacts,
    count_if(sm.severity_level = 'High')       as high_severity_impacts,
    avg(max_g_impact)                          as avg_g_force
from impacts i
left join sev_map sm
  on i.severity_code = sm.severity_code
group by shift_id, date_key
