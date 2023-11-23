{{ config(materialized="view") }}

with
    stag_promos as (select * from  {{ ref( "stg_promos" )}})

select *
from stag_promos
