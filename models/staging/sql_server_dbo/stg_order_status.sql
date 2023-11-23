{{ config(materialized="table") }}

with
    stag_orders as (select distinct (status) from  {{ source("sql_server_dbo", "orders") }}),
    cte1 as (
        select distinct
            {{ no_blank_surrograte("status") }} as status_id, status as des_status
        from stag_orders
    )

select *
from cte1

 
