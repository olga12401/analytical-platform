{{ config(materialized='table') }}

select distinct
    region,
    manager as regional_manager
from {{ ref('int_regional_orders') }}
