{{ config(materialized="view") }}

with
    stag_orders as (select * from {{ ref("stg_orders") }}),
    stag_events as (select order_id, event_id from {{ ref("stg_events") }}),
    cte as (
        select
            concat(
                o.order_id,
                user_id,
                address_id,
                promo_id,
                shipping_service_id,
                tracking_id,
                status_id
                --, e.event_id
            ) as order_id,
            o.order_id as order_items_id,
            o.user_id,
            address_id,
            promo_id,
            shipping_service_id,
            tracking_id,
            o.created_at_utc,
            status_id,
            -- e.event_id,
            order_cost_dollars,
            order_total_dollars,
            delivered_at_utc,
            estimated_delivery_at_utc,
            date_load_utc
        from stag_orders o
        -- join stag_events e on o.order_id = e.order_id
    ),
    cte1 as (
        select
            {{ dbt_utils.surrogate_key(["order_id"]) }} as order_id,
            order_items_id,
            user_id,
            address_id,
            promo_id,
            shipping_service_id,
            tracking_id,
            created_at_utc,
            status_id,
            -- event_id,
            order_cost_dollars,
            order_total_dollars,
            delivered_at_utc,
            estimated_delivery_at_utc,
            date_load_utc
        from cte
    )

select *
from cte1
