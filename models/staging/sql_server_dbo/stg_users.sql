{{ config(materialized="table") }}

with
    src_users as (select * from {{ source("sql_server_dbo", "users") }}),

    renamed_casted as (
        select
            cast(user_id as varchar(50)) as user_id,
            cast(updated_at as timestamp_ntz) as updated_at,
            cast(address_id as varchar(50)) as address_id,
            cast(last_name as varchar(50)) as last_name,
            cast(created_at as timestamp_ntz) as created_at,
            cast(phone_number as varchar(20)) as phone_number,
            cast(
                decode(total_orders, null, 0, total_orders) as varchar(50)
            ) as total_orders,
            cast(first_name as varchar(50)) as first_name,
            cast(email as varchar(100)) as email,
            cast(_fivetran_synced as timestamp_ntz) as date_load
        from src_users
    )

select *
from renamed_casted
