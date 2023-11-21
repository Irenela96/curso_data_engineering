{{ config(materialized="table") }}
{% set variable = obtener_valores("stg_promos","promo_id") %}

with
    src_promos as (select * from {{ source("sql_server_dbo", "promos") }}),
    renamed_casted as (
        select {{obtener_valores("stg_promos","promo_id")}}
    )

select *
from renamed_casted

