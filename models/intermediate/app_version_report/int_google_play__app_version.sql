with app_version_report as (

    select *
    from {{ ref('google_play__app_version_report') }}
),

adapter as (

    select 
        date_day,
        'google_play' as app_platform,
        package_name as app_name,
        app_version_code as app_version,
        device_uninstalls as deletions,
        crashes
    from app_version_report
)

select * 
from adapter