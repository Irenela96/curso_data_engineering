{{ config(materialized="table") }}

with
    src_order_items as (select * from {{ source("sql_server_dbo", "order_items") }}),
    surr1 as(
        select CONCAT(order_id, '_', product_id) as order_items_id,
        order_id
        from {{ source("sql_server_dbo", "order_items") }}
    ),
    surr2 as(
        select {{ dbt_utils.surrogate_key(["order_items_id"]) }} as order_items_id,
        order_id
        from surr1
    ),
    surr2_cast as(
        select cast(order_items_id as varchar(50)) as order_items_id,
        order_id
        from surr2
    ),
    renamed_casted as (
        select
            order_items_id,
            cast(oi.order_id as varchar(50)) as order_id,
            cast(product_id as varchar(50)) as product_id,
            cast(quantity as number(38, 0)) as quantity,
            convert_timezone('UTC', _fivetran_synced) as date_load_utc
        from src_order_items oi
        join surr2_cast sc on oi.order_id=sc.order_id
    )

select *
from renamed_casted

