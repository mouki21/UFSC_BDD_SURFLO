-- CONSULTA 9 — Desempenho médio das baterias por etapa e categoria
-- Objetivo: usar CTE para resumir as pontuações das baterias finalizadas e comparar
-- quantidade de baterias, média, maior e menor pontuação por etapa, categoria e fase.

WITH desempenho_baterias AS (
    SELECT
        b.id_etapa,
        b.id_categoria,
        b.fase,
        rb.id_bateria,
        COUNT(rb.id_participacao_bateria) AS atletas_avaliados,
        AVG(rb.pontuacao_total) AS media_pontuacao,
        MAX(rb.pontuacao_total) AS maior_pontuacao,
        MIN(rb.pontuacao_total) AS menor_pontuacao
    FROM BATERIA AS b
    INNER JOIN (
        SELECT
            pb.id_bateria,
            pb.id_participacao_bateria,
            res.pontuacao_total
        FROM PARTICIPACAO_BATERIA AS pb
        INNER JOIN RESULTADO_BATERIA AS res
            ON res.id_participacao_bateria = pb.id_participacao_bateria
    ) AS rb
        ON rb.id_bateria = b.id_bateria
    WHERE b.status = 'FINALIZADA'
    GROUP BY b.id_etapa, b.id_categoria, b.fase, rb.id_bateria
)
SELECT
    e.nome AS etapa,
    c.nome AS categoria,
    db.fase,
    COUNT(db.id_bateria) AS quantidade_baterias,
    SUM(db.atletas_avaliados) AS total_atletas_avaliados,
    ROUND(AVG(db.media_pontuacao), 2) AS media_das_baterias,
    MAX(db.maior_pontuacao) AS maior_pontuacao,
    MIN(db.menor_pontuacao) AS menor_pontuacao
FROM desempenho_baterias AS db
INNER JOIN ETAPA AS e
    ON e.id_etapa = db.id_etapa
INNER JOIN CATEGORIA AS c
    ON c.id_categoria = db.id_categoria
GROUP BY e.id_etapa, e.nome, c.id_categoria, c.nome, db.fase
ORDER BY e.nome ASC, c.nome ASC, db.fase ASC;
