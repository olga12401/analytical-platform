select
    o.row_id,
    o.order_id,

    case when o.discount > 0 then true else false end as has_discount,
    case when o.profit < 0 then true else false end as is_loss,

    case
        when r.status = 'Returned' then true
        else false
    end as is_returned

from {{ ref('stg_orders') }} o
left join {{ ref('stg_returns') }} r
    on o.order_id = r.order_id
