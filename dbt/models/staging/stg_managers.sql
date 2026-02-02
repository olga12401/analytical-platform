SELECT
    region,
    manager,
    _etl_loadtime
FROM {{ source('raw', 'managers') }}
