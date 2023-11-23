{{ config(materialized="view") }}

with
    stag_products as (select * from  {{ ref( "stg_products" )}})

select *
from stag_products
