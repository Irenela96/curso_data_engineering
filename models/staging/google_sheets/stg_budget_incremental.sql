-- Si se intenta cambiar el schema, da un "fail" -->
-- https://docs.getdbt.com/docs/build/incremental-models
{{ config(materialized="incremental", unique_key="_row", on_schema_change="fail") }}

with
    stg_budget_incremental as (
        select *
        from {{ source("google_sheets", "budget") }}
        -- el filtro es mejor meterlo ahí por eficiencia del programa
        {% if is_incremental() %}  -- si existe el histórico...

            where _fivetran_synced > (select max(_fivetran_synced) from {{ this }})  -- this indica este mismo modelo

        {% endif %}
    ),

    renamed_casted as (
        select _row, month, quantity, _fivetran_synced from stg_budget_incremental
    )

select *
from renamed_casted
