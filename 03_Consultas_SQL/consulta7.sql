-- CONSULTA 7 — Atletas que chegaram à final
-- Objetivo: recuperar os atletas que participaram de pelo menos uma bateria
-- da fase FINAL, utilizando uma subconsulta com IN.

SELECT
    a.id_atleta,
    a.primeiro_nome || ' ' || a.sobrenome AS atleta,
    c.nome AS categoria
FROM ATLETA AS a
INNER JOIN CATEGORIA AS c
    ON c.id_categoria = a.id_categoria
WHERE a.id_atleta IN (
    SELECT DISTINCT pb.id_atleta
    FROM PARTICIPACAO_BATERIA AS pb
    INNER JOIN BATERIA AS b
        ON b.id_bateria = pb.id_bateria
    WHERE b.fase = 'FINAL'
      AND b.status = 'FINALIZADA'
)
ORDER BY c.nome ASC, atleta ASC;
