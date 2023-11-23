{{ config(materialized="table") }}

with
    stag_products as (select * from  {{ ref( "stg_products" )}})

select *
from stag_products
