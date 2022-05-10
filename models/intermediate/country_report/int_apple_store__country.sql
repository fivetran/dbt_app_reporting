with country_report as (

    select *
    from {{ ref('apple_store__territory_report') }}
),

subsetted as (

    select 
        date_day,
        'apple_store' as type,
        app_name, 
        territory as country_name,
        country_code_alpha_2 as country_code,
        region,
        sub_region,
        deletions,
        total_downloads,
        page_views
    from country_report
)

select * from subsetted