{{ config(materialized='table') }}

with impacts as (
    select * from {{ ref('fct_impacts') }}
),
usage as (
    select * from {{ ref('fct_usage') }}
),
sev_map as (
    select * from {{ ref('severity_mapping') }}
)

select
    i.operator_id,
    count(*)                                   as total_impacts,
    count_if(sm.severity_level = 'High')       as high_severity_impacts,
    avg(i.max_g_impact)                        as avg_g_force,
    avg(i.max_duration)                        as avg_impact_duration,
    avg(i.impact_ratio)                        as avg_impact_ratio,
    sum(u.login_hrs)                           as total_login_hrs,
    nullif(count(*),0) / nullif(sum(u.login_hrs),0) as impacts_per_hour
from impacts i
left join usage u
    on i.operator_id = u.operator_id
   and i.date_key    = u.date_key
left join sev_map sm
    on i.severity_code = sm.severity_code
group by i.operator_id
