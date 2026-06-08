WITH source AS (
    SELECT * FROM {{ source('raw_data', 'raw_transferencias') }}
)
SELECT
    -- Dim_Tempo
    "ANO / MÊS" AS ano_mes,

    -- Dim_Localidade (Tratando Nulos)
    COALESCE(NULLIF(TRIM("UF"), ''), 'NI') AS uf,
    COALESCE(NULLIF(TRIM("CÓDIGO MUNICÍPIO SIAFI"), ''), '-1') AS codigo_municipio_siafi,
    UPPER(COALESCE(NULLIF(TRIM("NOME MUNICÍPIO"), ''), 'NÃO INFORMADO')) AS nome_municipio,

    -- Dim_Favorecido (Tratando Nulos)
    COALESCE(NULLIF(TRIM("CÓDIGO FAVORECIDO"), ''), '-1') AS codigo_favorecido,
    UPPER(COALESCE(NULLIF(TRIM("NOME FAVORECIDO"), ''), 'NÃO INFORMADO')) AS nome_favorecido,
    UPPER(COALESCE(NULLIF(TRIM("TIPO FAVORECIDO"), ''), 'NÃO INFORMADO')) AS tipo_favorecido,

    -- Dim_Programa (Tratando Nulos)
    COALESCE(NULLIF(TRIM("CÓDIGO PROGRAMA"), ''), '-1') AS codigo_programa,
    UPPER(COALESCE(NULLIF(TRIM("NOME PROGRAMA"), ''), 'NÃO INFORMADO')) AS nome_programa,
    COALESCE(NULLIF(TRIM("AÇÃO"), ''), 'NÃO INFORMADO') AS acao,
    UPPER(COALESCE(NULLIF(TRIM("NOME AÇÃO"), ''), 'NÃO INFORMADO')) AS nome_acao,
    UPPER(COALESCE(NULLIF(TRIM("LINGUAGEM CIDADÃ"), ''), 'NÃO INFORMADO')) AS linguagem_cidada,

    -- Fato_Transferencias (Convertendo String para Numeric/Float)
    CAST(REPLACE("VALOR TRANSFERIDO", ',', '.') AS NUMERIC) AS valor_transferido

FROM source