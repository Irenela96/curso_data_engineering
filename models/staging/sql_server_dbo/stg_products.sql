{{ config(materialized="table") }}

with
    src_products as (select * from {{ source("sql_server_dbo", "products") }}),

    renamed_casted as (
        select
            cast(product_id as varchar(50)) as product_id,
            cast(price as float) as price,
            cast(name as varchar(100)) as name,
            cast(inventory as number(38, 0)) as inventory,
            cast(_fivetran_synced as timestamp_ntz) as date_load
        from src_products
    )

select *
from renamed_casted
