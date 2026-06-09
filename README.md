# Projeto de Integração: Recursos Transferidos 💰

Este projeto, desenvolvido durante a disciplina de Banco de Dados (CIN 137) 2026.1, tem como objetivo implementar e comparar duas arquiteturas de Engenharia de Dados — ETL (Python/Pandas) e ELT (DBT/SQL) — a fim de modelar/higienizar dados de recursos públicos federais transferidos para prefeituras municipais nos anos de 2020, 2021 e 2022. Além disso, ele implementa uma **Modelagem dimensional — Esquema estrela —** transformando os registros em Data Warehouse organizado para Bussiness Inteligence (BI). 
**Relatório:** [abrir com @cin.ufpe.br](https://docs.google.com/document/d/13_4EbqKzTe6D9apB8OUTQCrfUcsL7ynbWn0Qt830Tr0/edit?usp=sharing)

## Objetivo e Desafios 🎯

- **Fonte:** [Portal da Transparência do Governo Federal](https://portaldatransparencia.gov.br/download-de-dados/transferencias)
- **Dados:** Planilhas mensais de Transferências de Recursos Públicos Federais, abrangendo a série histórica de Janeiro de 2020 a Dezembro de 2022 (período da pandemia de COVID-19).
- **Desafio:** Processar e unificar 36 arquivos que totalizam mais de 5,8 milhões de registros. O tratamento exigiu mapeamento de 'nulos mascarados' (como "-1" ou "sem informação"), conversão de tipos de dados numéricos que estavam em formato de texto devido à formatação brasileira de vírgulas, e a higienização textual para remover inconsistências de digitação.

## Arquitetura da Solução 🚧

1. **ETL (Python):**
   - **Extração:** Os dados brutos armazenados no Google Drive tiveram seus caminhos mapeados via Google Colab, permitindo a concatenação (empilhamento vertical) de todas as planilhas em um único DataFrame.
   - **Transformação:** Foi realizada a validação de esquema e o Data Profiling para identificar o preenchimento dos atributos. Colunas com baixa utilidade analítica ou de uso contábil interno do governo (como 'Plano Orçamentário' e 'Elemento Despesa') foram descartadas. Aplicaram-se sanitizações textuais (padronização em caixa alta e remoção de espaços) e *casting* da métrica "VALOR TRANSFERIDO" para `float64`. A modelagem extraiu valores únicos para compor as dimensões e tratou nulos através do conceito de Membro Desconhecido (Unknown Member), atribuindo o ID `-1`.
   - **Carregamento:** Exportação dos DataFrames modelados no formato Star Schema para um arquivo de banco de dados relacional (.db) através do método to_sql, disponibilizando os dados estruturados e limpos para o consumo analítico.

2. **ELT (DBT/SQL):**
   - **Extração:** 
   - **Carregamento:** 
   - **Transformação (DBT):** 

## Modelagem de Dados (Estrela) ⭐

O Data Warehouse foi estruturado utilizando o modelo *Star Schema*, composto pelas seguintes tabelas:

- **Dim_Tempo:** Fornece o contexto temporal (Ano/Mês) consolidado das transferências.
- **Dim_Localidade:** Mapeia a geografia dos repasses, incluindo a sigla da UF, nome e código SIAFI do município destinatário.
- **Dim_Favorecido:** Armazena dados de quem recebeu a transferência, detalhando a categoria (Pessoa Física, Jurídica, Fundo Público), nome e documento de identificação mascarado.
- **Dim_Programa:** Detalha as diretrizes orçamentárias, incluindo o nome oficial do programa, a ação executada e uma tradução chamada "Linguagem Cidadã", que simplifica o termo técnico para o público geral.
- **Fato_Transferencias:** A tabela central que concentra as métricas financeiras. Ela cruza as chaves estrangeiras (FKs) de todas as dimensões com o montante monetário líquido (`VALOR TRANSFERIDO`) de cada transação.

## Tecnologias Utilizadas 🧑‍💻

- **Python (Pandas):** Utilizado massivamente na fase ETL para concatenação, *data profiling*, higienização de strings e deduplicação de registros para a criação das dimensões.
- **Google Colab & Drive:** Ambiente de execução e armazenamento para os scripts de extração e tratamento inicial.
- **SQL:** Utilizado para a formulação de consultas analíticas sob medida e estruturação de *queries* diretamente na base de dados final.

## Arvore de Arquivos 🌳

```text
projeto_integracao/
├── .gitattributes             # Configuração do Git LFS (Arquivos grandes)
├── README.md
├── analysis/
│   └── ...                    # Scripts de consultas e análises SQL
└── notebooks/
    ├── ETL.ipynb              # Notebook com o pipeline de extração e transformação (Pandas)
    └── data/                  # Diretório com a base de dados pública unificada
        ├── 2020/              # Planilhas mensais do ano 2020
        ├── 2021/              # Planilhas mensais do ano 2021
        └── 2022/              # Planilhas mensais do ano 2022
```

## Run 🏃


## Resultados e Insights✔️

As consultas SQL na pasta `/analysis` demonstram o poder do modelo construído:

1.  **Análise de repasses à UFPE no recorte temporal:** Análise do volume de repasses, filtrando especificamente pelos que tinham como destino a UFPE, agrupados pelo par ano/mês, usando a `Fato_Transferencia`, a `Dim_Tempo` e a `Dim_Favorecido`.
2.  **Distribuição de verba da União a programas distintos:** Agrupamento de registros pelo programa a que se destinava o repasse, ordenando visando listar os 10 maiores recipientes usando a `Fato_Transferencia` e a `Dim_Programa`.
3.  **Mapeamento dos maiores pagamentos em parcela única:** Extração das 5 maiores transferências em parcela única da série histórica (sem agregações de soma), detalhando o recebedor, a finalidade e a data exata da transação, utilizando a `Fato_Transferencia`, `Dim_Programa`, a `Dim_Tempo` e a `Dim_Favorecido`.

> **Nota sobre a Qualidade dos Dados:** Durante o processo de ETL, foram identificados vários casos de dados incompletos (UF ausente, dentre outros) que foram devidamente tratados com identificadores específicos para sinalizar.

## 🚀 Como Executar (ETL && ELT)

### 🚀 Instruções de Execução (ETL)

Este repositório contém o script responsável pelas etapas de **Extração, Transformação e Carga (ETL)** dos dados de Transferências Financeiras do Governo Federal. O código foi desenvolvido para rodar no ambiente Google Colab, enviando os dados tratados diretamente para um Data Warehouse em nuvem (PostgreSQL).

#### 📂 Como acessar os Dados Brutos (Atalho no Drive)
Para facilitar a execução deste notebook e evitar o download pesado de gigabytes de arquivos CSV, os dados brutos foram disponibilizados em nuvem. Siga estes 3 passos simples antes de iniciar:

1. Acesse a pasta raiz do projeto clicando neste link: **[https://drive.google.com/drive/folders/1cqeaA2uAmvNbG1n9OtwtoXbrBhX91T6R?usp=sharing]**
2. No topo da tela, clique na setinha ao lado do nome da pasta e selecione a opção **"Adicionar atalho ao Google Drive"** (ou *Add shortcut to Drive*).
3. Escolha a opção **"Meu Drive"** (*My Drive*) e clique em Adicionar.

Feito isso, o Google Colab reconhecerá o atalho automaticamente e extrairá os quase 6 milhões de registros sem consumir a memória local da sua máquina.

#### ⚙️ Como Configurar e Rodar o Código no Colab
* **Passo 1 (Conexão com Drive):** Abra o arquivo do notebook (`ETL.ipynb`) no Google Colab. Ao rodar a primeira célula de código, autorize o Colab a montar o seu Google Drive.
* **Passo 2 (Credenciais do Banco):** Vá até a última célula de código (fase de Carga/Load). Se for rodar localmente, insira a sua string de conexão (`DATABASE_URL`) apontando para um banco PostgreSQL válido (recomendamos *Neon.tech* ou *Aiven*). *Nota: Por questões de segurança, as senhas foram removidas deste repositório público.*
* **Passo 3 (Execução):** No menu superior do Colab, clique em **Ambiente de execução > Executar tudo** (ou `Ctrl + F9`).

O script fará a unificação dos arquivos, a sanitização textual, o descarte de colunas redundantes e montará a estrutura dimensional (Star Schema), enviando a Tabela Fato e as Dimensões diretamente para o servidor nuvem em lotes (*chunks*).
