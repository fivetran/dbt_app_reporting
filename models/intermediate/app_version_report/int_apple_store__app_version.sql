with app_version_report as (

    select *
    from {{ ref('apple_store__app_version_report') }}
),

subsetted as (

    select 
        source_relation,
        date_day,
        'apple_store' as app_platform,
        app_name,
        app_name as inferred_app_name,
        cast(app_version as {{ dbt.type_string() }}) as app_version,
        sum(deletions) as deletions,
        sum(crashes) as crashes
    from app_version_report
    {{ dbt_utils.group_by(6) }}
)

select * 
from subsetted