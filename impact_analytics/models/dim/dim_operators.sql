{{ config(materialized='table') }}

with src as (select * from {{ ref('stg_usage_events') }})

select distinct
    operator_id,
    operator_login,
    first_name,
    last_name,
    mi,
    job_title,
    opr_class,
    org_code,
    access_id
from src
where operator_id is not null
