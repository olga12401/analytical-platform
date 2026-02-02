with orders as (

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

        product_category,
        product_subcategory,
        product_name,

        unit_price,
        order_quantity,
        sales,
        profit,
        discount,
        shipping_cost,
        product_base_margin,

        _etl_loadtime
    from {{ ref('stg_orders') }}

),

returns as (

    select
        order_id,
        status
    from {{ ref('stg_returns') }}

),

managers as (

    select
        region,
        manager
    from {{ ref('stg_managers') }}

)

select
    o.*,

    /* return flag */
    case
        when r.status = 'Returned' then true
        else false
    end as is_returned,

    /* regional manager */
    m.manager as regional_manager,

    /* derived metrics */
    (o.sales - o.shipping_cost) as net_sales,

    case
        when o.sales = 0 then 0
        else o.profit / o.sales
    end as profit_margin

from orders o
left join returns r
    on o.order_id = r.order_id
left join managers m
    on o.region = m.region
