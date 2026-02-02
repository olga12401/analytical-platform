{{ config(materialized='view') }}

select
    order_id,
    status
from {{ source('raw', 'returns') }}

