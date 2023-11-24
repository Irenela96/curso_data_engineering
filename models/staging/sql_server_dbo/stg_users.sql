{{ config(materialized="table") }}

with
    src_users as (select * from {{ source("sql_server_dbo", "users") }}),
    total_ord as(
        select user_id, count(*) as orders_total
        from {{ source("sql_server_dbo", "orders") }}
        group by user_id
    ),
    renamed_casted as (
        select
            cast(u.user_id as varchar(50)) as user_id,
            cast(first_name as varchar(50)) as first_name,
            cast(last_name as varchar(50)) as last_name,
            cast(email as varchar(100)) as email,
            cast(address_id as varchar(50)) as address_id,
            cast(replace(phone_number, '-', '') as number(38, 0)) as phone_number,
            cast(orders_total as number(38, 0)) as orders_total,
            convert_timezone('UTC', created_at) as created_at_utc,
            convert_timezone('UTC', updated_at) as updated_at_utc,
            convert_timezone('UTC', _fivetran_synced) as date_load_utc
        from src_users u
        join total_ord o on u.user_id = o.user_id
        order by orders_total desc, user_id
    )

select *
from renamed_casted
