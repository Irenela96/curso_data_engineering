{{ config(materialized="table") }}

with
    src_addresses as (select * from {{ source("sql_server_dbo", "addresses") }}),

    renamed_casted as (
        select
            cast(address_id as varchar(50)) as address_id,
            cast(address as varchar(150)) as address,
            cast(zipcode as number(38, 0)) as zipcode,
            cast(state as varchar(50)) as state,
            cast(country as varchar(50)) as country,
            convert_timezone('UTC', _fivetran_synced) as date_load_utc
        from src_addresses
    )

select *
from renamed_casted
