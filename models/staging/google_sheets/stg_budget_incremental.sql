{{ config(
    materialized='incremental'
    ) 
    }}


WITH stg_budget_incremental AS (
    SELECT * 
    FROM {{ source('google_sheets','budget') }}
-- el filtro es mejor meterlo ahí por eficiencia del programa
{% if is_incremental() %} -- si existe el histórico...

	  where _fivetran_synced > (select max(_fivetran_synced) from {{ this }}) -- this indica este mismo modelo

{% endif %}
    ),

renamed_casted AS (
    SELECT
          _row
        , month
        , quantity 
        , _fivetran_synced
    FROM stg_budget_incremental
    )

SELECT * FROM renamed_casted