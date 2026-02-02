select
    customer_name,
    customer_segment,
    region,
    order_id,
    order_date,
    order_quantity,
    sales,
    profit,
    discount,
    shipping_cost

from {{ ref('stg_orders') }}

