{{ config(materialized="view") }}

with
    stag_orders as (select * from {{ ref("stg_orders") }})

select *
from stag_orders
