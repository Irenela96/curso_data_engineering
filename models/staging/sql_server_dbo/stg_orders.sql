
{{
  config(
    materialized='table'
  )
}}

WITH src_orders AS (
    SELECT * 
    FROM {{ source('sql_server_dbo', 'orders') }}
    ),

renamed_casted AS (
    SELECT
        order_id,
        shipping_service, 
        shipping_cost, --metrica
        address_id, --dim: location
        created_at,
        DECODE(promo_id,'','Sin promoción',promo_id) AS promo_id,
        estimated_delivery_at,
        order_cost, --métrica
        user_id, --> dim users
        DECODE(order_total,NULL,0,order_total) AS order_total,
        delivered_at,
        tracking_id, --> no hace falta sacarlo porque solo está en orders
        status, 
        _fivetran_synced AS date_load
    FROM src_orders
    )

SELECT * FROM renamed_casted