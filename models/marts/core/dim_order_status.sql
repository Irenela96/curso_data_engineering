{{ config(materialized="view") }}

with
    stag_order_status as (select * from  {{ ref( "stg_order_status" )}})

select *
from stag_order_status
