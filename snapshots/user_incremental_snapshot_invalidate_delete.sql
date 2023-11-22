-- Foto de como están los datos de origen
-- de primeras el dbt_valid_to está a nulo porque no hay cambios
-- cuando se produzca un cambio en el registro, 
-- en este campo aparecerá la fecha hasta la que fue el registro válido
{% snapshot user_incremental_snapshot_invalidate_delete %}

    {{
        config(
            target_schema="snapshots",
            unique_key="user_id",
            strategy="timestamp",
            updated_at="f_carga",
            invalidate_hard_deletes=True,
        )
    }}

    select *
    from {{ "stg_user_incremental" }}

{% endsnapshot %}
