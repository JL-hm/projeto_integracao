WITH staging AS (
    SELECT DISTINCT ano_mes FROM {{ ref('stg_transferencias') }} WHERE ano_mes IS NOT NULL
)
SELECT
    ROW_NUMBER() OVER (ORDER BY ano_mes) AS id_tempo,
    ano_mes
FROM staging