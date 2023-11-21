{{ config(materialized="table") }}

with
    src_products as (select * from {{ source("sql_server_dbo", "products") }}),

    renamed_casted as (
        select
            cast(product_id as varchar(50)) as product_id,
            cast(price as float) as price,
            cast(name as varchar(100)) as name,
            cast(inventory as number(38, 0)) as inventory,
            convert_timezone('UTC', _fivetran_synced) as date_load_utc
        from src_products
    )

select *
from renamed_casted
