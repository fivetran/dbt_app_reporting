with traffic_source_report as (

    select *
    from {{ ref('apple_store__source_type_report') }}
),

subsetted as (

    select 
        date_day,
        'apple_store' as app_platform,
        app_name, 
        source_type as traffic_source_type,
        total_downloads as downloads,
        page_views
    from traffic_source_report
)

select * from subsetted