{{ config(materialized="view") }}

with
    stag_order_items as (select * from {{ ref('stg_order_items') }})

select *
from stag_order_items
