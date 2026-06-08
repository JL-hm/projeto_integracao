WITH staging AS (
    SELECT DISTINCT codigo_favorecido, nome_favorecido, tipo_favorecido 
    FROM {{ ref('stg_transferencias') }}
)
SELECT
    ROW_NUMBER() OVER (ORDER BY codigo_favorecido, tipo_favorecido) AS id_favorecido,
    codigo_favorecido,
    nome_favorecido,
    tipo_favorecido
FROM staging