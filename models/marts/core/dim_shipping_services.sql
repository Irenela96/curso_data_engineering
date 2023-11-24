{{ config(materialized="view") }}

with
    stag_shipping_services as (select * from  {{ ref( "stg_shipping_services" )}})

select *
from stag_shipping_services
