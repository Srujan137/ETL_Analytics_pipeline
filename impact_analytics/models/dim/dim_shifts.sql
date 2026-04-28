{{ config(materialized='table') }}

with src as (select * from {{ ref('stg_usage_events') }})

select distinct
    shift_id,
    shift_name,
    shift_start_ts,
    shift_end_ts
from src
where shift_id is not null
