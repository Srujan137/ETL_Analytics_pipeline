{{ config(materialized='table') }}

with ev as (select * from {{ ref('stg_usage_events') }})

select
    /* grain: one row per impact_id (if missing, fall back to usage_event_id) */
    coalesce(impact_id, usage_event_id) as impact_event_id,

    /* FKs (natural keys) */
    operator_id,
    vehicle_id,
    shift_id,
    to_date(impact_ts)                  as date_key,
    md5(coalesce(impact_loc,''))        as location_id,

    /* measures & descriptors */
    impact_ts,
    impact_loc,
    severity,
    severity_code,
    impact_level,
    impact_direction,
    status_pre_impact,
    status_at_impact,
    status_post_impact,
    max_g_impact,
    max_duration,
    impact_ratio
from ev
where impact_ts is not null
