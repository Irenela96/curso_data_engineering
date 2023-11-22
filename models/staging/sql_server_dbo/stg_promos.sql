{{ config(materialized="table") }}

with
    src_promos as (select * from {{ source("sql_server_dbo", "promos") }}),
    renamed_casted as (
        select
            cast(
                {{ dbt_utils.surrogate_key(["promo_id"]) }} as varchar(50)
            ) as promo_id,
            cast(promo_id as varchar(50)) as des_promo,
            cast(discount as float) as discount_percentage,
            cast(status as varchar(50)) as status,
            convert_timezone('UTC', _fivetran_synced) as date_load_utc
        from src_promos
    )

select *
from renamed_casted
union all
select
    '9999' as promo_id,
    'Sin promo' as des_promo,
    '0' as discount,
    'inactive' as status,
    convert_timezone('UTC', {{ dbt_date.now("America/New_York") }}) as date_load_utc
