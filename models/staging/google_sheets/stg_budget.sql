{{ config(materialized="view") }}

with
    src_budget_products as (select * from {{ source("google_sheets", "budget") }}),

    renamed_casted as (
        select _row, product_id, quantity, month as date, _fivetran_synced as date_load
        from src_budget_products
    )

select *
from renamed_casted
