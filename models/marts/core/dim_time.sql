{{ 
    config(
        materialized='incremental', 
        sort='date_day',
        dist='date_day',
        pre_hook="alter session set timezone = 'UTC'; alter session set week_start = 7;" 
        ) }}

with date as (
    {{ dbt_utils.date_spine(
        datepart="day",
        start_date="cast('2000-01-01' as date)",
        end_date="cast(current_date()+1 as date)"
    )
    }}  
)

select
    year(date_day)*10000+month(date_day)*100+day(date_day) as date_id,
    convert_timezone('UTC', date_day) as date_utc,    
    year(date_day) as year,
    month(date_day) as month,
    day(date_day) as day,
    monthname(date_day) as desc_month,
    dayname(date_day) as desc_day,
    year(date_day)*100+month(date_day) as year_month_id,
    date_day-1 as preview_day,
    year(date_day)||weekiso(date_day)||dayofweek(date_day) as year_week_day,
    weekiso(date_day) as week
from date
order by
    date_day desc
