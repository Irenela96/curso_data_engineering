{{
  config(
    materialized='table'
  )
}}

WITH renamed_casted AS (
	(SELECT 
        COUNT(*) "Numero pedidos",
        A.state "Estado"
        FROM {{ ref('stg_orders') }} O
        JOIN {{ ref('stg_addresses') }} A ON A.address_id = O.address_id
        GROUP BY A.state
    )
)

SELECT * FROM renamed_casted