
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
        event_id,
        page_url,
        event_type,
        DECODE(product_id,NULL,'Sin usuario registrado',user_id),
        DECODE(product_id,NULL,'Sin productos seleccionados',product_id) AS product_id,
        session_id,
        created_at,
        DECODE(order_id,NULL,'Sin pedido realizado',order_id) AS order_id,
        _fivetran_synced AS date_load
    FROM src_events
    )

SELECT * FROM renamed_casted