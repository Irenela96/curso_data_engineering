{{ config(materialized="view") }}
{%- set keywords = obtener_valores(ref("dim_events"), 'event_type') -%}

with
    dim_events as (select * from  {{ ref("dim_events")}}),
    dim_users as (select * from  {{ ref("dim_users")}}),
    cte1 as (
        select
            session_id,
            e.user_id,
            first_name,
            email,
            min(e.created_at_utc) as first_event_time_utc,
            max(e.created_at_utc) as last_event_time_utc,
            datediff(minutes,min(e.created_at_utc),max(e.created_at_utc)) session_length_minutes,   
            {% for keyword in keywords %}
                count(case when event_type =
                    '{{ keyword }}' then 1 else null end) as {{ keyword }} {% if not loop.last %},{% endif %}
            {% endfor %}                

        from dim_events e
        join dim_users u on e.user_id=u.user_id
        group by session_id, e.user_id,first_name,email
    )

select *
from cte1