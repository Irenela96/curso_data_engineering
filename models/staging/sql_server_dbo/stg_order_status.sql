{{ config(materialized="table") }}

with
    stag_orders as (select distinct (status) from  {{ source("sql_server_dbo", "orders") }}),
    cte1 as (
        select distinct
            {{ dbt_utils.surrogate_key(["status"]) }} as status_id, status as des_status
        from stag_orders
    ),
    cte2 as (select cast(status_id as varchar(50)) as status_id, des_status from cte1)

select *
from cte2

 
