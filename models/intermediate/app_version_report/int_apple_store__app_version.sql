with app_version_report as (

    select *
    from {{ ref('apple_store__app_version_report') }}
),

subsetted as (

    select 
        date_day,
        'apple_store' as app_platform,
        app_name, 
        app_version,
        deletions,
        crashes
    from app_version_report
)

select * from subsetted