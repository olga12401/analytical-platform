{{ config(materialized='table') }}

select distinct
    customer_name,
    customer_segment,
    region
from {{ ref('int_customer_orders') }}
