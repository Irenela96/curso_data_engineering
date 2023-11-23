{{ config(materialized="table") }}

with
    stag_addresses as (select * from  {{ ref("stg_addresses")}})

select *
from stag_addresses
