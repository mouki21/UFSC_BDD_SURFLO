-- CONSULTA 6 — Etapas com pontuação acima da média geral
-- Objetivo: listar resultados individuais por etapa cuja pontuação seja superior
-- à média de todos os resultados de etapa. A média é obtida por subconsulta escalar.

SELECT
    a.id_atleta,
    a.primeiro_nome || ' ' || a.sobrenome AS atleta,
    c.nome AS categoria,
    e.nome AS etapa,
    re.pontos_obtidos
FROM RESULTADO_ETAPA AS re
INNER JOIN ATLETA AS a
    ON a.id_atleta = re.id_atleta
INNER JOIN CATEGORIA AS c
    ON c.id_categoria = re.id_categoria
INNER JOIN ETAPA AS e
    ON e.id_etapa = re.id_etapa
WHERE re.pontos_obtidos > (
    SELECT AVG(pontos_obtidos)
    FROM RESULTADO_ETAPA
)
ORDER BY re.pontos_obtidos DESC, c.nome ASC, atleta ASC;
