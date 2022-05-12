with os_version_report as (

    select *
    from {{ ref('apple_store__platform_version_report') }}
),

subsetted as (

    select 
        date_day,
        'apple_store' as app_platform,
        app_name, 
        platform_version as os_version,
        total_downloads as downloads,
        deletions,
        crashes
    from os_version_report
)

select * from subsetted