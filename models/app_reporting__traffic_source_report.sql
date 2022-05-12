with unioned as (

    {{ dbt_utils.union_relations(relations=[ref('int_apple_store__traffic_source'), ref('int_google_play__traffic_source')]) }}

)

select *
from unioned