{{ config(materialized='table') }}

select
    customer_name,
    customer_segment,
    region,

    count(distinct order_id) as total_orders,
    sum(order_quantity) as total_quantity,
    sum(sales) as total_sales,
    sum(net_sales) as total_net_sales,
    sum(profit) as total_profit,

    avg(discount) as avg_discount,
    avg(profit_margin) as avg_profit_margin

from {{ ref('fct_orders') }}
group by 1, 2, 3
