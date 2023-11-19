
{{
  config(
    materialized='table'
  )
}}

WITH src_products AS (
    SELECT * 
    FROM {{ source('sql_server_dbo', 'products') }}
    ),

renamed_casted AS (
    SELECT
        cast(product_id as varchar(50)) as product_id,
        cast(price as float) as price,
        cast(name as varchar(100)) as name,
        cast(inventory as number(38,0)) as inventory,
        cast(_fivetran_synced as timestamp_ntz) as date_load
    FROM src_products
    )

SELECT * FROM renamed_casted