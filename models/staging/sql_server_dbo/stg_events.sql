{{ config(materialized="table") }}

with
    src_events as (select * from {{ source("sql_server_dbo", "events") }}),

    renamed_casted as (
        select
            cast(event_id as varchar(50)) as event_id,
            cast(page_url as varchar(200)) as page_url,
            cast(event_type as varchar(50)) as event_type,
            cast(user_id as varchar(50)) as user_id,
            cast(decode(product_id, '', 'na', product_id) as varchar(50)) as product_id,
            cast(session_id as varchar(50)) as session_id,
            cast(created_at as timestamp_ntz) as created_at,
            cast(decode(order_id, '', 'na', order_id) as varchar(50)) as order_id,
            cast(_fivetran_synced as timestamp_ntz) as date_load
        from src_events
    )

select *
from renamed_casted
