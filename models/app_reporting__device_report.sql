with unioned as (

    {{ dbt_utils.union_relations(relations=[ref('int_apple_store__device'), ref('int_google_play__device')]) }}

)

select *
from unioned