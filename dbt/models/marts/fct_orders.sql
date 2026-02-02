{{ config(materialized='table') }}

select
    row_id,
    order_id,
    order_date,
    ship_date,
    ship_mode,
    order_priority,
    product_container,
    customer_name,
    customer_segment,
    zip_code,
    state,
    city,
    region,
    regional_manager,
    product_category,
    product_subcategory,
    product_name,
    unit_price,
    order_quantity,
    sales,
    profit,
    discount,
    shipping_cost,
    net_sales,
    profit_margin,
    is_returned,
    _etl_loadtime
from {{ ref('int_orders_enriched') }}

