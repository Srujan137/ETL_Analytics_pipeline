{{ config(materialized='table') }}

with ev as (select * from {{ ref('stg_usage_events') }})

select
    usage_event_id,            -- grain: one row per usage session
    operator_id,
    vehicle_id,
    shift_id,
    to_date(impact_ts)  as date_key,  -- aligns with dim_time for same day
    usage_rec_count,
    login_hrs,
    max_speed,
    mins_to_logoff
from ev
group by
    usage_event_id, operator_id, vehicle_id, shift_id, to_date(impact_ts),
    usage_rec_count, login_hrs, max_speed, mins_to_logoff
