{{ config(materialized='table') }}

with d as (
    select distinct to_date(impact_ts) as date_day
    from {{ ref('stg_usage_events') }}
    where impact_ts is not null
)

select
    date_day                                  as date_key,
    date_day                                  as full_date,
    extract(year    from date_day)            as year,
    extract(quarter from date_day)            as quarter,
    extract(month   from date_day)            as month,
    to_char(date_day, 'Mon')                  as month_name,
    extract(day     from date_day)            as day_of_month,
    to_char(date_day, 'DY')                   as day_name,
    case when dayofweek(date_day) in (0,6) then true else false end as is_weekend
from d
