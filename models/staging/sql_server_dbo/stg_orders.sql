{{ config(materialized="table") }}

with
    src_orders as (select * from {{ source("sql_server_dbo", "orders") }}),
    cte as (
        select
            cast(order_id as varchar(50)) as order_id,
            cast(user_id as varchar(50)) as user_id,
            cast(address_id as varchar(50)) as address_id,
            {{ no_blank_surrograte('promo_id') }} as promo_id,
            {{ no_blank_surrograte('shipping_service') }} as shipping_service_id,
            cast(
                decode(tracking_id, '', '9999', tracking_id) as varchar(50)
            ) as tracking_id,
            {{ no_blank_surrograte('status') }} as status_id,
            cast(shipping_cost as float) as shipping_cost_dollars,
            cast(order_cost as float) as order_cost_dollars,
            cast(coalesce(order_total, 0) as float) as order_total_dollars,
            row_number() over (partition by user_id order by created_at) num_orders_user,
            count(order_id) over (partition by user_id) total_num_orders_user,
            convert_timezone('UTC', created_at) as created_at_utc,
            convert_timezone('UTC', delivered_at) as delivered_at_utc,
            convert_timezone('UTC', estimated_delivery_at) as estimated_delivery_at_utc,
            round(datediff(day,created_at_utc,delivered_at_utc)) order_time_days,          
            convert_timezone('UTC', _fivetran_synced) as date_load_utc
        from src_orders
    )

select *
from cte
