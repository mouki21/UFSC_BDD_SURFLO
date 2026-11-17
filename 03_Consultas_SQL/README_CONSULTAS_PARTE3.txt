SURFLO — CONSULTAS SQL | PARTE 3
=================================

Arquivos
--------
consulta1.sql a consulta10.sql

Compatibilidade
---------------
Consultas escritas para SQLite e para o novo esquema definido em
01_criacao_bdd_SURFLO.sql. Execute-as na base surflo.db, depois de
carregar os dados de 02_insertion_donnees_SURFLO.sql.

Resumo das consultas
--------------------
1. Classificação geral final — view VW_CLASSIFICACAO_GERAL_CALCULADA.
2. Estatísticas das notas por juiz — COUNT, SUM, AVG, MIN e MAX.
3. Ocupação e situação dos ingressos — LEFT JOIN, COALESCE, CASE e NULL.
4. Participação nas ações ambientais — GROUP BY e HAVING.
5. Contratos de patrocínio — agregações e HAVING.
6. Resultados acima da média geral — subconsulta escalar.
7. Atletas que chegaram à final — subconsulta IN.
8. Praias com ações ambientais e voluntários — subconsulta EXISTS.
9. Desempenho das baterias — CTE e agregações.
10. Transações — SAVEPOINT, ROLLBACK TO, COMMIT e ROLLBACK.

Matriz de atendimento aos requisitos do professor
--------------------------------------------------
- COUNT, SUM, AVG, MIN, MAX: consulta2 (também outras).
- INNER JOIN: consultas 1, 2, 3, 4, 5, 6, 7, 8 e 9.
- LEFT JOIN: consultas 3 e 4.
- JOIN com pelo menos 3 tabelas: consultas 1, 2, 3, 4, 6 e 9.
- HAVING pelo menos 2 vezes: consultas 4 e 5.
- Subconsulta escalar: consulta6.
- Subconsulta com IN: consulta7.
- Subconsulta com EXISTS: consulta8.
- CTE: consulta9.
- Tratamento de NULL em pelo menos 2 pontos: consulta3 (COALESCE e CASE quando não há ingresso associado; o LEFT JOIN preserva a etapa).
- GROUP BY com pelo menos 2 colunas: consultas 2, 3, 4, 5 e 9.
- ORDER BY ASC e DESC: consultas 1 a 9.
- COMMIT, ROLLBACK e SAVEPOINT: consulta10 (dois SAVEPOINTs, dois ROLLBACK TO, dois COMMITs e um ROLLBACK integral).