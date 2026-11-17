SURFLO
Sistema de Gestão de Competições de Surf e Conservação Marinha
==============================================================

Projeto Final do Semestre
Universidade Federal de Santa Catarina (UFSC)
CIN 8003 - Bancos de Dados e Aplicações (20262)
Professor: Moisés Lima Dutra
Aluno: Matteo D'ALENA (947721)


1. SOBRE O PROJETO
------------------
O SURFLO é um banco de dados relacional (SQLite) para gerenciar um campeonato
de surf e ações de conservação marinha. O sistema cobre:

- 1 campeonato, com 5 etapas e 5 categorias (Pro homem, Pro mulher, Open misto,
  Esperança homem e Esperança mulher);
- atletas, inscrições, baterias, juízes e avaliações;
- resultados por bateria e por etapa, classificação geral e premiações;
- patrocinadores e contratos de patrocínio;
- bilheteria (ingressos e capacidade das etapas);
- autorizações de uso das praias e seus responsáveis;
- ações ambientais e voluntários.

Os dados são fictícios, criados para testar e demonstrar o funcionamento.


2. ESTRUTURA DO REPOSITÓRIO
---------------------------
01_Banco_de_Dados/
    01_criacao_bdd_SURFLO.sql        DDL: tabelas, restrições, triggers, view, índices
    02_insertion_donnees_SURFLO.sql  DML: dados de demonstração
    03_criar_banco.py                Python: executa os dois scripts e cria o banco
    surflo.db                        Banco SQLite gerado e validado
    README.txt                       Notas da implementação

02_Modelagem/
    regras_SURFLO.txt                Regras de negócio (RN01 a RN79) e hipóteses (H01 a H15)
    MER_SURFLO_Mermaid.mmd           Modelo entidade-relacionamento (Mermaid)
    Modelo_Relacional_SURFLO.pdf     Modelo relacional exportado

03_Consultas_SQL/
    consulta1.sql ... consulta10.sql As 10 consultas da Parte 3
    README_CONSULTAS_PARTE3.txt      Resumo e matriz de requisitos

04_Apresentacao/
    SURFLO_Apresentacao.pptx         Slides da apresentação (com notas do orador)


3. O QUE O BANCO CONTÉM 
-------------------------------------------------
- 28 tabelas, 11 triggers, 1 view (VW_CLASSIFICACAO_GERAL_CALCULADA)
  e 6 índices criados explicitamente.
- Restrições usadas: PRIMARY KEY (inclusive compostas), FOREIGN KEY com ações
  referenciais, NOT NULL, UNIQUE, CHECK e DEFAULT.
- Triggers: limite de 4 atletas e 4 juízes por bateria; finalização da bateria
  só com 4 atletas, 4 juízes e 16 avaliações; geração automática de
  RESULTADO_BATERIA; autorização de praia aprovada e válida; capacidade de
  ingressos; coerência da autorização com a praia e o período da etapa.

Volume de dados:
  1 campeonato | 5 etapas | 5 categorias | 80 atletas | 400 inscrições
  175 baterias | 700 participações | 700 juízes por bateria
  2.800 avaliações | 700 resultados de bateria | 400 resultados por etapa
  80 linhas de classificação geral | 48 prêmios | 80 atribuições de prêmio
  250 ingressos (40 vendidos + 10 disponíveis por etapa)


4. COMO USAR
------------
Requisito: Python 3 (o módulo sqlite3 já vem incluído).

Recriar o banco a partir dos scripts (opcional, o surflo.db já está pronto):
    cd 01_Banco_de_Dados
    python 03_criar_banco.py
O script apaga e recria surflo.db, executa o DDL e o DML e roda
PRAGMA foreign_key_check e PRAGMA integrity_check. Se algum deles falhar,
ele interrompe com erro.

Executar uma consulta (exemplo com a consulta 1):
    python -c "import sqlite3; c=sqlite3.connect('01_Banco_de_Dados/surflo.db'); [print(r) for r in c.execute(open('03_Consultas_SQL/consulta1.sql',encoding='utf-8').read())]"
Também é possível abrir surflo.db no DB Browser for SQLite e colar o conteúdo
de cada arquivo. A consulta 10 usa uma tabela TEMPORARY e várias instruções
(BEGIN, SAVEPOINT, ROLLBACK, COMMIT), por isso deve ser executada como script.


5. CONSULTAS SQL (Parte 3)
--------------------------
 1. Classificação geral final (view)
 2. Estatísticas das notas por juiz (COUNT, SUM, AVG, MIN, MAX)
 3. Ocupação e situação dos ingressos (LEFT JOIN, COALESCE, CASE)
 4. Participação nas ações ambientais (GROUP BY, HAVING)
 5. Contratos de patrocínio (agregações, HAVING)
 6. Resultados acima da média geral (subconsulta escalar)
 7. Atletas que chegaram à final (subconsulta IN)
 8. Praias com ações ambientais e voluntários (subconsulta EXISTS)
 9. Desempenho das baterias (CTE)
10. Transações (SAVEPOINT, ROLLBACK TO, COMMIT, ROLLBACK)
Detalhes e matriz de requisitos em 03_Consultas_SQL/README_CONSULTAS_PARTE3.txt.


6. HIPÓTESES E LIMITAÇÕES
-------------------------
- A tabela de pontos por posição (100, 90, 80 ... 5) é provisória (RN43/RN44).
  O esquema não possui uma tabela de pontuação: os pontos entram pelo DML.
- O desempate da classificação geral usa o id do atleta, critério técnico e
  provisório (RN50/RN51). O critério esportivo oficial ainda precisa ser
  definido pela organização.
- CLASSIFICACAO_GERAL é um snapshot da view; não há trigger que o atualize.
- Depois que uma bateria é finalizada, o trigger bloqueia novos INSERTs em
  AVALIACAO, mas um UPDATE de nota não é bloqueado (RN38 parcialmente
  implementada).
- O gerenciamento de pagamentos está fora do escopo (RN67).
- A implementação cobre um único campeonato e não possui interface de usuário.
