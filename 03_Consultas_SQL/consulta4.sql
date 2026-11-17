-- CONSULTA 4 — Participação nas ações ambientais
-- Objetivo: identificar ações ambientais com pelo menos cinco voluntários,
-- mostrando a praia, o tipo de ação e o número de participantes.

SELECT
    aa.id_acao_ambiental,
    aa.descricao,
    aa.tipo_acao,
    p.nome AS praia,
    COUNT(pa.id_voluntario) AS quantidade_voluntarios
FROM ACAO_AMBIENTAL AS aa
INNER JOIN PRAIA AS p
    ON p.id_praia = aa.id_praia
LEFT JOIN PARTICIPACAO_ACAO AS pa
    ON pa.id_acao_ambiental = aa.id_acao_ambiental
GROUP BY aa.id_acao_ambiental, aa.descricao, aa.tipo_acao, p.nome
HAVING COUNT(pa.id_voluntario) >= 5
ORDER BY quantidade_voluntarios DESC, aa.data_acao ASC;
