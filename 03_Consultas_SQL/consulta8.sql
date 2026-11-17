-- CONSULTA 8 — Praias com ações ambientais efetivamente realizadas
-- Objetivo: listar praias que possuem ao menos uma ação ambiental com voluntários
-- registrados. A condição de existência é verificada por uma subconsulta EXISTS.

SELECT
    p.id_praia,
    p.nome AS praia,
    p.cidade,
    p.estado
FROM PRAIA AS p
WHERE EXISTS (
    SELECT 1
    FROM ACAO_AMBIENTAL AS aa
    INNER JOIN PARTICIPACAO_ACAO AS pa
        ON pa.id_acao_ambiental = aa.id_acao_ambiental
    WHERE aa.id_praia = p.id_praia
)
ORDER BY p.estado ASC, p.cidade ASC, p.nome ASC;
