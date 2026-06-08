WITH staging AS (
    SELECT DISTINCT uf, codigo_municipio_siafi, nome_municipio 
    FROM {{ ref('stg_transferencias') }}
)
SELECT
    ROW_NUMBER() OVER (ORDER BY uf, codigo_municipio_siafi) AS id_localidade,
    uf,
    codigo_municipio_siafi,
    nome_municipio
FROM staging