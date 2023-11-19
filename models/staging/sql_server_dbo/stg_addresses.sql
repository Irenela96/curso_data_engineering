
{{
  config(
    materialized='table'
  )
}}

WITH src_addresses AS (
    SELECT * 
    FROM {{ source('sql_server_dbo', 'addresses') }}
    ),

renamed_casted AS (
    SELECT
        cast(address_id as varchar(50)) as address_id,
        cast(zipcode as number(38,0)) as zipcode,
        cast(country as varchar(50)) as country,
        cast(address as varchar(150)) as address,
        cast(state as varchar(50)) as state,
        cast(_fivetran_synced as timestamp_ntz) as date_load
    FROM src_addresses
    )

SELECT * FROM renamed_casted