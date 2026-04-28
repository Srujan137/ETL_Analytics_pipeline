{{ config(materialized='table') }}

with src as (select * from {{ ref('stg_usage_events') }})

select distinct
    vehicle_id,
    vehicle_name,
    make,
    model,
    year,
    vehicle_type,
    mil_threshold
from src
where vehicle_id is not null
