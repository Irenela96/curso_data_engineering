{{ config(materialized="table") }}

with
    src_order_items as (select * from {{ source("sql_server_dbo", "order_items") }}),

    renamed_casted as (
        select
            cast(order_id as varchar(50)) as order_id,
            cast(product_id as varchar(50)) as product_id,
            cast(quantity as number(38, 0)) as quantity,
            convert_timezone('UTC', _fivetran_synced) as date_load_utc
        from src_order_items
    )

select *
from renamed_casted
