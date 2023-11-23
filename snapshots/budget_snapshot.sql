-- Foto de como están los datos de origen
-- de primeras el dbt_valid_to está a nulo porque no hay cambios
-- cuando se produzca un cambio en el registro, 
-- en este campo aparecerá la fecha hasta la que fue el registro válido

{% snapshot budget_snapshot %}

{{
    config(
      target_schema='snapshots',
      unique_key='_row',
      strategy='timestamp',
      updated_at='_fivetran_synced',
    )
}}

select * from {{ source('google_sheets', 'budget') }}

{% endsnapshot %}