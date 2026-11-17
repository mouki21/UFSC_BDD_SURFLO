-- CONSULTA 3 — Ocupação e situação dos ingressos por etapa
-- Objetivo: comparar ingressos vendidos, disponíveis e cancelados com a capacidade
-- de cada etapa. O LEFT JOIN mantém etapas mesmo quando não possuem ingressos.
-- COALESCE e CASE tratam valores nulos.

SELECT
    e.id_etapa,
    e.nome AS etapa,
    p.nome AS praia,
    e.capacidade,
    COUNT(i.id_ingresso) AS total_ingressos_cadastrados,
    SUM(CASE WHEN i.status = 'VENDIDO' THEN 1 ELSE 0 END) AS ingressos_vendidos,
    SUM(CASE WHEN i.status = 'DISPONIVEL' THEN 1 ELSE 0 END) AS ingressos_disponiveis,
    SUM(CASE WHEN i.status = 'CANCELADO' THEN 1 ELSE 0 END) AS ingressos_cancelados,
    COALESCE(ROUND(SUM(CASE WHEN i.status = 'VENDIDO' THEN i.preco ELSE 0 END), 2), 0) AS receita_bruta_registrada,
    CASE
        WHEN COUNT(i.id_ingresso) = 0 THEN 'Sem ingressos cadastrados'
        WHEN SUM(CASE WHEN i.status = 'VENDIDO' THEN 1 ELSE 0 END) >= e.capacidade THEN 'Capacidade atingida'
        ELSE 'Ainda ha capacidade'
    END AS situacao_capacidade
FROM ETAPA AS e
INNER JOIN PRAIA AS p
    ON p.id_praia = e.id_praia
LEFT JOIN INGRESSO AS i
    ON i.id_etapa = e.id_etapa
GROUP BY e.id_etapa, e.nome, p.nome, e.capacidade
ORDER BY ingressos_vendidos DESC, e.nome ASC;
