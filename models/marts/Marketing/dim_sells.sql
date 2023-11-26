{{ config(materialized="view") }}
{%- set keywords = obtener_valores(ref("stg_events"), 'event_type') -%}

with
    dim_users as (select * from  {{ ref("dim_users")}}),
    dim_location as (select * from  {{ ref("dim_location")}}),
    fact_orders as (select * from  {{ ref("fact_orders")}}),
    dim_promos as (select * from  {{ ref("dim_promos")}}),
    dim_order_items as (select * from  {{ ref("dim_order_items")}}),
    cte1 as (
        select
            u.user_id,
            first_name,
            last_name,
            email,
            phone_number,
            u.created_at_utc,
            u.updated_at_utc,
            address,
            zipcode,
            state,
            country, 
            total_num_orders_user,
            order_cost_dollars as total_order_cost_usd,
            shipping_cost_dollars as total_shipping_cost_usd,
            discount_percentage as total_discount_usd,
            count(oi.product_id) as total_quantity_products
        from dim_users u
        join dim_location l on u.address_id=l.address_id
        join fact_orders o on u.user_id=o.user_id
        join dim_promos p on o.promo_id=p.promo_id
        join dim_order_items oi on o.order_items_id=oi.order_id
        group by o.order_id
    )

select *
from cte1