{{ config(materialized="table") }}

with
    stag_orders as (
        select distinct (shipping_service) from {{ source("sql_server_dbo", "orders") }}
    ),
    stag_orders_clean as (
        select
            decode(shipping_service, '', '9999', shipping_service) as shipping_service
        from stag_orders
    ),
    cte1 as (
        select distinct
            {{ dbt_utils.surrogate_key(["shipping_service"]) }} as shipping_service_id,
            shipping_service as des_shipping_service
        from stag_orders_clean
    ),
    cte2 as (
        select
            cast(shipping_service_id as varchar(50)) as shipping_service_id,
            des_shipping_service
        from cte1
    )

select *
from cte2
