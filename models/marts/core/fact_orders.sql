{{ config(materialized="table") }}

with
    stag_orders as (select * from {{ ref("stg_orders") }}),
    stag_order_items as (select* from {{ ref("stg_order_items")}}),
    cte1 as (
        select
            -- ids
            o.order_id,
            user_id,
            shipping_service_id,
            address_id,
            promo_id,
            status_id,
            tracking_id,
            oi.order_items_id,
            -- dollars
            order_cost_dollars,
            order_total_dollars,
            -- dates
            created_at_utc,
            estimated_delivery_at,
            delivered_at,
            o.date_load_utc as date_load_orders_utc,
            oi.date_load_utc as date_load_order_items_utc
        from stag_orders o
        join stag_order_items oi on o.order_id = oi.order_id
        order by order_id
    )

select *
from cte1
