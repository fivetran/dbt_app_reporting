with traffic_source_report as (

    select *
    from {{ ref('stg_google_play__store_performance_source') }}
),

adapter as (

    select 
        date_day,
        'google' as app_platform,
        package_name as app_name,
        traffic_source as source_type, -- should we include search terms and/or utms for certain kinds of traffic sources?
        store_listing_acquisitions as downloads,
        store_listing_visitors as page_views
    from traffic_source_report
)

select * 
from adapter