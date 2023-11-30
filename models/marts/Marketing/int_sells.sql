{{ config(materialized="view") }}
{%- set keywords = obtener_valores(ref("dim_events"), 'event_type') -%}

with
dim_users as (select * from {{ ref("dim_users") }}),

dim_location as (select * from {{ ref("dim_location") }}),

fact_orders as (select * from {{ ref("fact_orders") }}),

dim_promos as (select * from {{ ref("dim_promos") }}),

dim_order_items as (
    select
        order_id,
        count(product_id) num_products_dif,
        sum(quantity) num_products
    from {{ ref("dim_order_items") }}
    group by order_id
),
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
        oi.num_products as total_quantity_products,
        oi.num_products_dif as total_dif_products
    from dim_users as u
    inner join dim_location as l on u.address_id = l.address_id
    inner join fact_orders as o on u.user_id = o.user_id
    inner join dim_promos as p on o.promo_id = p.promo_id
    inner join dim_order_items as oi on o.order_items_id = oi.order_id
)

select *
from cte1
