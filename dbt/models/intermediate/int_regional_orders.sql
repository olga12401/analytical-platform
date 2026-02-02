select
    o.order_id,
    o.region,
    m.manager,
    o.sales,
    o.profit,
    o.shipping_cost

from {{ ref('stg_orders') }} o
left join {{ ref('stg_managers') }} m
    on o.region = m.region