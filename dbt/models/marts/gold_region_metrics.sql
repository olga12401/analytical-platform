{{ config(materialized='table') }}

select
    region,
    regional_manager,

    count(distinct order_id) as total_orders,
    count(distinct case when is_returned then order_id end) as returned_orders,

    count(distinct case when is_returned then order_id end)
        / nullif(count(distinct order_id), 0) as return_rate,

    sum(sales) as total_sales,
    sum(net_sales) as total_net_sales,
    sum(profit) as total_profit

from {{ ref('fct_orders') }}
group by 1, 2
