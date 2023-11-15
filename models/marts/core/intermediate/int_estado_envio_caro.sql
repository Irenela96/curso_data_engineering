{{
  config(
    materialized='table'
  )
}}

WITH stg_addresses AS(
	SELECT 
		address_id, 
		state 
	FROM {{ ref('stg_addresses') }} 
), renamed_casted as(
    SELECT 
        order_id,
        shipping_cost,
        shipping_service,
        state
    FROM {{ ref('stg_addresses') }}  O
    JOIN stg_addresses E ON O.address_id=E.address_id
    WHERE shipping_cost = (SELECT
                            MAX(shipping_cost) 
                            FROM {{ ref('stg_orders') }} 
                            )
)

SELECT * FROM renamed_casted