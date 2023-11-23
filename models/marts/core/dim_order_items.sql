{{ config(materialized="table") }}

with
    stag_order_items as (select * from {{ ref('stg_order_items') }}),

    cte as (
        select
            
        from stag_order_items_id
    )

select *
from cte
