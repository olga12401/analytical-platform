{{ config(materialized='table') }}

SELECT
    order_id,
    status AS return_status
FROM {{ ref('stg_returns') }}
