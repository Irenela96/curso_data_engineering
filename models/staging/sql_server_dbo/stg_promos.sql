{{ config(materialized="table") }}

with
    src_promos as (select * from {{ source("sql_server_dbo", "promos") }}),

    renamed_casted as (
        select
            cast(
                decode(promo_id, '', 'Sin promo', promo_id) as varchar(50)
            ) as promo_id,
            cast(discount as float) as discount,
            cast(status as varchar(50)) as status,
            cast(_fivetran_synced as timestamp_ntz) as date_load
        from src_promos
    )

select *
from renamed_casted
