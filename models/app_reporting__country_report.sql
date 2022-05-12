with unioned as (

    {{ dbt_utils.union_relations(relations=[ref('int_apple_store__country'), ref('int_google_play__country')]) }}

)

select *
from unioned