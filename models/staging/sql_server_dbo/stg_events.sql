{{ config(materialized="table") }}

with
    src_events as (select * from {{ source("sql_server_dbo", "events") }}),

    renamed_casted as (
        select
            cast(event_id as varchar(50)) as event_id,
            cast(page_url as varchar(200)) as page_url,
            cast(event_type as varchar(50)) as event_type,
            cast(user_id as varchar(50)) as user_id,
            cast(
                decode(product_id, '', '9999', product_id) as varchar(50)
            ) as product_id,
            cast(session_id as varchar(50)) as session_id,
            convert_timezone('UTC', created_at) as created_at_utc,
            cast(decode(order_id, '', '9999', order_id) as varchar(50)) as order_id,
            convert_timezone('UTC', _fivetran_synced) as date_load_utc
        from src_events
    )

select *
from renamed_casted
