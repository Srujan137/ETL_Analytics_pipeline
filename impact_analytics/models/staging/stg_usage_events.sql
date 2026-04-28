{{ config(materialized='view') }}

with raw_impacts as (
    select * from IMPACTDATA.RAW.FORKLIFT_IMPACTS_NEW
)

select
    /* natural keys / ids */
    cast(Usage_Event_ID as string)  as usage_event_id,
    cast(Veh_Ext_ID    as string)  as vehicle_id,
    cast(Opr_Ext_ID    as string)  as operator_id,
    cast(Shift_ID      as string)  as shift_id,
    cast(Impact_ID     as string)  as impact_id,

    /* shift */
    cast(Shift_Name  as string)                         as shift_name,
    try_to_timestamp(Shift_Start)                       as shift_start_ts,
    try_to_timestamp(Shift_End)                         as shift_end_ts,

    /* vehicle attributes (kept here for dim_vehicles) */
    cast(Vehicle      as string) as vehicle_name,
    cast(Make         as string) as make,
    cast(Model        as string) as model,
    try_to_number(Year)          as year,
    cast(Vehicle_Type as string) as vehicle_type,

    /* operator descriptive (kept here for dim_operators) */
    cast(Operator   as string) as operator_login,
    cast(Last_Name  as string) as last_name,
    cast(First_Name as string) as first_name,
    cast(MI         as string) as mi,
    cast(Org_Code   as string) as org_code,
    cast(Access_ID  as string) as access_id,
    cast(Opr_Class  as string) as opr_class,
    cast(Job_Title  as string) as job_title,

    /* impact core */
    try_to_timestamp(Impact_Date)  as impact_ts,
    cast(Status_Pre_Impact  as string) as status_pre_impact,
    cast(Status_At_Impact   as string) as status_at_impact,
    cast(Status_Post_Impact as string) as status_post_impact,
    cast(Impact_Loc         as string) as impact_loc,
    try_to_number(Max_G_Impact)        as max_g_impact,
    try_to_number(Max_Duration)        as max_duration,
    try_to_number(Impact_Ratio)        as impact_ratio,
    try_to_number(XPos)                as xpos,
    try_to_number(YPos)                as ypos,
    cast(Severity       as string)     as severity,
    cast(Severity_Code  as string)     as severity_code,
    try_to_number(Mins_to_Logoff)      as mins_to_logoff,
    cast(Impact_Level   as string)     as impact_level,
    try_to_number(MIL_Threshold)       as mil_threshold,
    cast(Impact_Direction as string)   as impact_direction,

    /* usage metrics */
    try_to_number(Usage_Rec_Count)     as usage_rec_count,
    try_to_number(Login_Hrs)           as login_hrs,
    try_to_number(Max_Speed)           as max_speed
from raw_impacts
