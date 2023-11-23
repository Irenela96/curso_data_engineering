{{ config(materialized="table") }}

with
    stag_users as (select * from {{ ref('stg_users') }}),

    cte as (
        select
            user_id,
            first_name,
            last_name,
            phone_number,
            email,
            address_id,
            created_at_utc,
            updated_at_utc,
            date_load_utc
        from stag_users
    )

select *
from cte
