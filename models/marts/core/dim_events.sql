{{ config(materialized="view") }}

with
    stag_events as (select * from  {{ ref("stg_events")}}),
    cte1 as (
        select
            event_id,
            page_url,
            event_type,
            user_id,
            product_id,
            session_id,
            order_id,
            created_at_utc,            
            date_load_utc
        from stag_events
    )

select *
from cte1
