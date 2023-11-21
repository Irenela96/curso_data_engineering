{{ config(materialized="view") }}

with
    src_budget_products as (select * from {{ source("google_sheets", "budget") }}),

    renamed_casted as (
        select
            cast({{ dbt_utils.surrogate_key(["_row"]) }} as varchar(50)) as _row,
            cast(product_id as varchar(50)) as product_id,
            cast(quantity as number(38, 0)) as quantity,
            convert_timezone('UTC', month) as date_utc,
            convert_timezone('UTC', _fivetran_synced) as date_load_utc
        from src_budget_products
    )

select *
from renamed_casted
