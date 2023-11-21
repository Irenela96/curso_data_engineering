{{ config(materialized="table") }}

with
    src_orders as (select distinct (shipping_service) from {{ "stg_orders" }}),
    src_orders_clean as (
        select
            decode(shipping_service, '', '9999', shipping_service) as shipping_service
        from src_orders
    ),
    renamed_casted as (
        select distinct
            cast(
                {{ dbt_utils.surrogate_key(["shipping_service"]) }} as varchar(50)
            ) as shipping_service_id,
            shipping_service as des_shipping_service
        from src_orders_clean
    )

select *
from renamed_casted
