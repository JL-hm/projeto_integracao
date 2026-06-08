WITH staging AS (
    SELECT DISTINCT codigo_programa, nome_programa, acao, nome_acao, linguagem_cidada 
    FROM {{ ref('stg_transferencias') }}
)
SELECT
    ROW_NUMBER() OVER (ORDER BY codigo_programa, acao) AS id_programa,
    codigo_programa,
    nome_programa,
    acao,
    nome_acao,
    linguagem_cidada
FROM staging