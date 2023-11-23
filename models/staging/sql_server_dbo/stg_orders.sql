{{ config(materialized="table") }}

with
    src_orders as (select * from {{ source("sql_server_dbo", "orders") }}),
    cte as (
        select
            cast(order_id as varchar(50)) as order_id,
            cast(user_id as varchar(50)) as user_id,
            cast(address_id as varchar(50)) as address_id,
            cast(
                decode(
                    promo_id, '', '9999', {{ dbt_utils.surrogate_key(["promo_id"]) }}
                ) as varchar(50)
            ) as promo_id,
            cast(
                decode(
                    shipping_service,
                    '',
                    '9999',
                    {{ dbt_utils.surrogate_key(["shipping_service"]) }}
                ) as varchar(50)
            ) as shipping_service_id,
            cast(
                decode(tracking_id, '', '9999', tracking_id) as varchar(50)
            ) as tracking_id,
            cast(shipping_cost as float) as shipping_cost_dollars,
            cast(order_cost as float) as order_cost_dollars,
            cast(coalesce(order_total, 0) as float) as order_total_dollars,
            cast(
                coalesce({{ dbt_utils.surrogate_key(["status"]) }}, '9999') as varchar(
                    50
                )
            ) as status_id,
            convert_timezone('UTC', delivered_at) as delivered_at,
            convert_timezone('UTC', estimated_delivery_at) as estimated_delivery_at,
            convert_timezone('UTC', created_at) as created_at_utc,
            convert_timezone('UTC', _fivetran_synced) as date_load_utc
        from src_orders
    )

select *
from cte
