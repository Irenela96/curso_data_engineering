{{ config(materialized="view") }}

with
    stag_orders as (select * from {{ ref("stg_orders") }}),
    stag_events as (select order_id, event_id from {{ ref("stg_events") }}),
    cte as (
        select
            o.order_id,
            o.user_id,
            address_id,
            promo_id,
            shipping_service_id,
            tracking_id,
            o.created_at_utc,
            status_id,
            e.event_id,
            order_cost_dollars,
            order_total_dollars,
            delivered_at_utc,
            estimated_delivery_at_utc,
            created_at_utc,
            date_load_utc
        from stag_orders o
        join stag_events e on o.order_id = e.order_id
    )


select *
from cte
