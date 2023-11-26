SELECT *
FROM {{ ref('stg_orders') }} 
WHERE delivered_at_utc < created_at_utc and
estimated_delivery_at_utc < created_at_utc