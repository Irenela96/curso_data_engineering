{%- set keywords = obtener_valores(ref("stg_events"), 'event_type') -%}
{%- set values = (["https://%","%shipping%","%product%"]) -%}

SELECT DISTINCT page_url
FROM {{ ref("stg_events") }}
WHERE 
    page_url LIKE '{{values[0]}}'
    AND (
      {% for keyword in keywords %}
          page_url NOT LIKE '%{{ keyword }}%' {% if not loop.last %} AND {% endif %}
      {% endfor %}
    )
    AND page_url NOT LIKE '{{values[1]}}'
    AND page_url NOT LIKE '{{values[2]}}'
