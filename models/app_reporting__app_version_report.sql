with unioned as (

    {{ dbt_utils.union_relations(relations=[ref('int_apple_store__app_version'), ref('int_google_play__app_version')]) }}

)

select *
from unioned