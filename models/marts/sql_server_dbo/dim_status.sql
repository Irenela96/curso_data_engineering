{{ config(materialized="table") }}

with
    src_orders as (select distinct (status) from {{ "stg_orders" }}),
    renamed_casted as (
        select distinct
            cast({{ dbt_utils.surrogate_key(["status"]) }} as varchar(50)) as status_id,
            status as des_status
        from src_orders
    )

select *
from renamed_casted
