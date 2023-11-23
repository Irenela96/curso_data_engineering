{{ config(materialized="table") }}

with
    stag_orders as (
        select distinct (shipping_service) from {{ source("sql_server_dbo", "orders") }}
    ),
    cte1 as (
        select
            {{ no_blank_surrograte("shipping_service") }} as shipping_service_id,
            decode(shipping_service, '', 'None', shipping_service) as des_shipping_service
        from stag_orders
    )

select *
from cte1
