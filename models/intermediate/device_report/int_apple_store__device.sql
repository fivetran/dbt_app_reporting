with device_report as (

    select *
    from {{ ref('apple_store__device_report') }}
),

subsetted as (

    select 
        date_day,
        'apple_store' as app_platform,
        app_name, 
        device,
        sum(total_downloads) as downloads,
        sum(deletions) as deletions
    from device_report
    {{ dbt_utils.group_by(4) }}
)

select * 
from subsetted