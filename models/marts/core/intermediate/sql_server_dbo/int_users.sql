{{ config(materialized="table") }}

with
    stag_users as (select * from {{ "stg_users" }}),
    stag_orders as (select user_id, count(*) as total_orders from {{ "stg_orders" }} group by user_id),

    cte as (
        select
            u.user_id,
            u.address_id,
            u.last_name,
            u.first_name,
            u.created_at_utc,
            u.updated_at_utc,
            cast(replace(u.phone_number, '-', '') as number(38, 0)) as phone_number,
            o.total_orders,
            u.email,
            u.date_load_utc
        from stag_users u
        join stag_orders o on u.user_id = o.user_id 
    )

select *
from cte
