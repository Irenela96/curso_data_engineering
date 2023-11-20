
{{
  config(
    materialized='table'
  )
}}

WITH src_promos AS (
    SELECT * 
    FROM {{ source('sql_server_dbo', 'promos') }}
    ),

renamed_casted AS (
    SELECT
        cast(DECODE(promo_id,'','Sin promo',promo_id) as varchar(50)) as promo_id,
        cast(discount as float) as discount,
        cast(status as varchar(50)) as status,
        cast(_fivetran_synced as timestamp_ntz) as date_load
    FROM src_promos
    )

SELECT * FROM renamed_casted