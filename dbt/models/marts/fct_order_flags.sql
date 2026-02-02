{{ config(materialized='table') }}

select
    row_id,
    order_id,
    has_discount,
    is_loss,
    is_returned
from {{ ref('int_orders_flags') }}
