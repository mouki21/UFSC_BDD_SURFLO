-- CONSULTA 1 — Classificação geral final do campeonato
-- Objetivo: apresentar o ranking por categoria, calculado pela soma dos três melhores
-- resultados de cada atleta nas cinco etapas. A view é a fonte dinâmica do cálculo.

SELECT
    c.nome AS categoria,
    a.id_atleta,
    a.primeiro_nome || ' ' || a.sobrenome AS atleta,
    cg.pontuacao_total,
    cg.quantidade_resultados_contabilizados AS resultados_contabilizados,
    cg.posicao_geral
FROM VW_CLASSIFICACAO_GERAL_CALCULADA AS cg
INNER JOIN ATLETA AS a
    ON a.id_atleta = cg.id_atleta
   AND a.id_categoria = cg.id_categoria
INNER JOIN CATEGORIA AS c
    ON c.id_categoria = cg.id_categoria
WHERE cg.id_campeonato = 1
ORDER BY c.nome ASC, cg.posicao_geral ASC;
