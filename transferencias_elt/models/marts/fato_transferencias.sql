WITH staging AS (
    SELECT * FROM {{ ref('stg_transferencias') }}
),
dim_tempo AS (SELECT * FROM {{ ref('dim_tempo') }}),
dim_localidade AS (SELECT * FROM {{ ref('dim_localidade') }}),
dim_favorecido AS (SELECT * FROM {{ ref('dim_favorecido') }}),
dim_programa AS (SELECT * FROM {{ ref('dim_programa') }})

SELECT
    ROW_NUMBER() OVER () AS id_transferencia,
    dt.id_tempo,
    dl.id_localidade,
    df.id_favorecido,
    dp.id_programa,
    stg.valor_transferido
FROM staging stg
LEFT JOIN dim_tempo dt ON stg.ano_mes = dt.ano_mes
LEFT JOIN dim_localidade dl 
    ON stg.uf = dl.uf AND stg.codigo_municipio_siafi = dl.codigo_municipio_siafi AND stg.nome_municipio = dl.nome_municipio
LEFT JOIN dim_favorecido df 
    ON stg.codigo_favorecido = df.codigo_favorecido AND stg.nome_favorecido = df.nome_favorecido AND stg.tipo_favorecido = df.tipo_favorecido
LEFT JOIN dim_programa dp 
    ON stg.codigo_programa = dp.codigo_programa AND stg.nome_programa = dp.nome_programa AND stg.acao = dp.acao AND stg.nome_acao = dp.nome_acao AND stg.linguagem_cidada = dp.linguagem_cidada