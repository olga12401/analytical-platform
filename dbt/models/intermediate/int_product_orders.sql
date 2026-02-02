select
    product_category,
    product_subcategory,
    product_name,
    order_id,
    order_date,
    unit_price,
    order_quantity,
    sales,
    profit

from {{ ref('stg_orders') }}