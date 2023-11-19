
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
        cast(order_id as varchar(50)) as order_id ,
        cast(shipping_service as varchar(20)) as shipping_service, 
        cast(shipping_cost as float) as shipping_cost, 
        cast(address_id as varchar(50)) as address_id, 
        cast(created_at as timestamp_ntz) as created_at,
        cast(DECODE(promo_id,'','na',promo_id) as varchar(50)) as promo_id,
        cast(estimated_delivery_at as timestamp_ntz) as estimated_delivery_at,
        cast(order_cost as float) as order_cost, 
        cast(user_id as varchar(50)) as user_id, 
        cast(DECODE(order_total,NULL,0,order_total) as float) as order_total,
        cast(delivered_at as timestamp_ntz) as delivered_at,
        cast(tracking_id as varchar(50)) as tracking_id,
        cast(DECODE(status,NULL,'na',status) as varchar(20)) as status,
        cast(_fivetran_synced as timestamp_ntz) as date_load
    FROM src_orders
    )

SELECT * FROM renamed_casted