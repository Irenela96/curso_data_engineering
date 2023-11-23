{% macro no_blank_surrograte(column) %}
    cast(
        decode(
            {{ column }},
            '',
            '9999',
            md5(cast(coalesce(cast({{ column }} as varchar), '') as varchar))
        ) as varchar(50)
    )
{% endmacro %}
