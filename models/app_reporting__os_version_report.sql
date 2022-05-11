with unioned as (

    {{ dbt_utils.union_relations(relations=[ref('int_apple_store__os_version'), ref('int_google_play__os_version')]) }}

)

select *
from unioned