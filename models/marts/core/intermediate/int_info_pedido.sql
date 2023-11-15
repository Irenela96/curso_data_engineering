{{
  config(
    materialized='table'
  )
}}

WITH stg_addresses AS (
    SELECT A.address_id,
		    address
	FROM {{ ref('stg_addresses') }} A
	JOIN {{ ref('stg_users') }} U ON A.address_id = U.address_id
), renamed_casted AS (
	(SELECT
        user_id, 
        A.address, 
        tracking_id,
        order_cost
        FROM {{ ref('stg_orders') }} AS O
        JOIN stg_addresses AS A
        ON O.ADDRESS_ID = A.ADDRESS_ID
    )
)

SELECT * FROM renamed_casted