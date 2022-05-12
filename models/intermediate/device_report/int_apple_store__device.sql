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
        total_downloads as downloads,
        deletions
    from device_report
)

select * from subsetted