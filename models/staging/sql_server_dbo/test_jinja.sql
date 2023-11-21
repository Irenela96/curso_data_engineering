-- ------------------
-- LA MEJOR OPCIÓN --> ES DINÁMICO
-- ------------------
{% set event_types = obtener_valores(ref("stg_events"), "event_type") %}
with
    stg_events as (select * from {{ ref("stg_events") }}),

    renamed_casted as (
        select
            user_id,
            {%- for event_type in event_types %}
                sum(
                    case when event_type = '{{event_type}}' then 1 end
                ) as {{ event_type }}_amount
                {%- if not loop.last %},{% endif -%}
            {% endfor %}
        from stg_events
        group by 1
    )

select *
from renamed_casted