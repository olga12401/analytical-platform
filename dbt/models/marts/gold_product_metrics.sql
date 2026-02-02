{{ config(materialized='table') }}

select
    product_category,
    product_subcategory,
    product_name,

    count(distinct order_id) as total_orders,
    sum(order_quantity) as total_quantity_sold,
    sum(sales) as total_sales,
    sum(net_sales) as total_net_sales,
    sum(profit) as total_profit

from {{ ref('fct_orders') }}
group by 1, 2, 3
