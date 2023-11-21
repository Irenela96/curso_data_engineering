{{ config(materialized="table") }}

with
    cte_my_date as (
        select dateadd(hour, seq4(), '2021-02-10 08:00:05.000 +0000') as my_date
        from table(generator(rowcount => 50000))
    )
select
    cast({{ dbt_utils.surrogate_key(["my_date"]) }} as varchar(50)) as time_id,
    convert_timezone('UTC', my_date) as date_utc,
    to_timestamp(my_date) as date_timestamp_ntz,
    to_date(my_date) as date_date,
    to_time(my_date) as time,
    year(my_date) as year,
    month(my_date) as month,
    monthname(my_date) as month_name,
    day(my_date) as day,
    dayofweek(my_date) as day_of_week,
    weekofyear(my_date) as week_of_year,
    dayofyear(my_date) as day_of_year,
    hour(my_date) as hour
from cte_my_date
