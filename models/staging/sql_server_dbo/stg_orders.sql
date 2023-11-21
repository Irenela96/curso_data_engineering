{{ config(materialized="table") }}

with
    src_orders as (select * from {{ source("sql_server_dbo", "orders") }}),

    renamed_casted as (
        select
            cast(order_id as varchar(50)) as order_id,
            cast(shipping_service as varchar(20)) as shipping_service,
            cast(shipping_cost as float) as shipping_cost_dollars,
            cast(address_id as varchar(50)) as address_id,
            convert_timezone('UTC', created_at) as created_at_utc,
            cast(
                decode(
                    promo_id, '', '9999', {{ dbt_utils.surrogate_key(["promo_id"]) }}
                ) as varchar(50)
            ) as promo_id,
            convert_timezone('UTC', estimated_delivery_at) as estimated_delivery_at,
            cast(order_cost as float) as order_cost_dollars,
            cast(user_id as varchar(50)) as user_id,
            cast(coalesce(order_total, 0) as float) as order_total_dollars,
            convert_timezone('UTC', delivered_at) as delivered_at,
            cast(tracking_id as varchar(50)) as tracking_id,
            cast(coalesce(status, '9999') as varchar(20)) as status,
            convert_timezone('UTC', _fivetran_synced) as date_load_utc
        from src_orders
    )

select *
from renamed_casted
