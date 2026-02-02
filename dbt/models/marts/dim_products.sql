{{ config(materialized='table') }}

select distinct
    product_category,
    product_subcategory,
    product_name,
    unit_price
from {{ ref('int_product_orders') }}
