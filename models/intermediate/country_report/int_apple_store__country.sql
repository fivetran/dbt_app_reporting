with country_report as (

    select *
    from {{ ref('apple_store__territory_report') }}
),

subsetted as (

    select 
        date_day,
        'apple_store' as platform_type,
        app_name, 
        territory_long as country_long,
        territory_short as country_short,
        region,
        sub_region,
        total_downloads as downloads,
        deletions,
        page_views
    from country_report
)

select * from subsetted