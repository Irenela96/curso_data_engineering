
{{
  config(
    materialized='table'
  )
}}

WITH src_order_items AS (
    SELECT * 
    FROM {{ source('sql_server_dbo', 'order_items') }}
    ),

renamed_casted AS (
    SELECT
        cast(order_id as varchar(50)) as order_id,
        cast(product_id as varchar(50)) as product_id,
        cast(quantity as number(38,0)) as quantity,
        cast(_fivetran_synced as timestamp_ntz) as date_load
    FROM src_order_items
    )

SELECT * FROM renamed_casted