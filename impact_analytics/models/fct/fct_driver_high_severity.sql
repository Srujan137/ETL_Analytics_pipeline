{{ config(materialized='table') }}

with impacts as (

    select 
        ue.operator_id,
        ue.first_name,
        ue.last_name,
        sm.severity,
        sm.severity_code
    from {{ ref('stg_usage_events') }} ue
    left join {{ ref('severity_mapping') }} sm 
        on cast(ue.severity_code as int) = sm.severity_code

    where sm.severity_code >= 3  -- High and above (3 = High, 4 = Severe)
),

driver_high_severity as (

    select
        operator_id,
        first_name,
        last_name,
        count(*) as total_high_impacts,
        avg(severity_code) as avg_severity_level
    from impacts
    group by operator_id, first_name, last_name

)

select * from driver_high_severity
