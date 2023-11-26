{{
    config(
        materialized='incremental',
        unique_key='order_details_id',
        on_schema_change='fail'
    )
}}

with
stag_orders as (select * from {{ ref("stg_orders") }}),

stag_events as (
    select
        order_id,
        event_id
    from {{ ref("stg_events") }}
    where event_type = 'package_shipped'
),

cte as (
    select
        o.order_id as order_items_id,
        o.user_id,
        address_id,
        promo_id,
        shipping_service_id,
        tracking_id,
        o.created_at_utc,
        status_id,
        e.event_id,
        shipping_cost_dollars,
        order_cost_dollars,
        order_total_dollars,
        num_orders_user,
        total_num_orders_user,
        delivered_at_utc,
        estimated_delivery_at_utc,
        order_time_days, 
        date_load_utc,
        concat(
            o.order_id,
            user_id,
            address_id,
            promo_id,
            shipping_service_id,
            tracking_id,
            status_id,
            e.event_id
        ) as order_id
    from stag_orders as o
    inner join stag_events as e on o.order_id = e.order_id
),

cte1 as (
    select
            {{ dbt_utils.generate_surrogate_key(["order_id"]) }} as order_id,
            order_items_id,
            user_id,
            address_id,
            promo_id,
            shipping_service_id,
            tracking_id,
            status_id,
            event_id,
            shipping_cost_dollars,
            order_cost_dollars,
            order_total_dollars,
            num_orders_user,
            total_num_orders_user,
            created_at_utc,
            estimated_delivery_at_utc,
            delivered_at_utc,
            order_time_days,    
            date_load_utc
from cte
)

select *
from cte1

{% if is_incremental() %}
where date_load_utc > (select max(date_load_utc) from {{ this }})
{% endif %}
