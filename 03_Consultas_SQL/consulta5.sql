-- CONSULTA 5 — Análise dos contratos de patrocínio
-- Objetivo: calcular o investimento total por patrocinador e identificar
-- patrocinadores cujo apoio financeiro total supera R$ 10.000.

SELECT
    s.id_sponsor,
    s.nome AS patrocinador,
    COUNT(cp.id_campeonato) AS quantidade_contratos,
    ROUND(SUM(cp.valor_patrocinio), 2) AS investimento_total,
    ROUND(AVG(cp.valor_patrocinio), 2) AS valor_medio_contrato
FROM SPONSOR AS s
INNER JOIN CONTRATO_PATROCINIO AS cp
    ON cp.id_sponsor = s.id_sponsor
GROUP BY s.id_sponsor, s.nome
HAVING SUM(cp.valor_patrocinio) > 10000
ORDER BY investimento_total DESC, patrocinador ASC;
