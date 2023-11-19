
{{
  config(
    materialized='table'
  )
}}

WITH src_events AS (
    SELECT * 
    FROM {{ source('sql_server_dbo', 'events') }}
    ),

renamed_casted AS (
    SELECT
        cast(event_id as varchar(50)) as event_id,
        cast(page_url as varchar(200)) as page_url,
        cast(event_type as varchar(50)) as event_type,
        cast(user_id as varchar(50)) as user_id,
        cast(DECODE(product_id,'','na',product_id) as varchar(50)) as product_id,
        cast(session_id as varchar(50)) as session_id,
        cast(created_at as timestamp_ntz) as created_at,
        cast(DECODE(order_id,'','na',order_id) as varchar(50)) as order_id,
        cast(_fivetran_synced as timestamp_ntz) as date_load
    FROM src_events
    )

SELECT * FROM renamed_casted