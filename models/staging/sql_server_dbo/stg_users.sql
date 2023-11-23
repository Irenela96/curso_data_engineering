{{ config(materialized="table") }}

with
    src_users as (select * from {{ source("sql_server_dbo", "users") }}),

    renamed_casted as (
        select
            cast(user_id as varchar(50)) as user_id,
            convert_timezone('UTC', updated_at) as updated_at_utc,
            cast(address_id as varchar(50)) as address_id,
            cast(last_name as varchar(50)) as last_name,
            convert_timezone('UTC', created_at) as created_at_utc,
            cast(replace(phone_number, '-', '') as number(38, 0)) as phone_number,
            cast(first_name as varchar(50)) as first_name,
            cast(email as varchar(100)) as email,
            convert_timezone('UTC', _fivetran_synced) as date_load_utc
        from src_users
    )

select *
from renamed_casted
