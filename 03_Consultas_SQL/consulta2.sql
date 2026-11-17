-- CONSULTA 2 — Estatísticas de avaliação por juiz
-- Objetivo: analisar o volume e o padrão das notas atribuídas por cada juiz,
-- incluindo quantidade, soma, média, menor nota e maior nota.

SELECT
    j.id_juiz,
    j.primeiro_nome || ' ' || j.sobrenome AS juiz,
    COUNT(av.id_avaliacao) AS quantidade_avaliacoes,
    ROUND(SUM(av.nota), 2) AS soma_notas,
    ROUND(AVG(av.nota), 2) AS media_notas,
    MIN(av.nota) AS menor_nota,
    MAX(av.nota) AS maior_nota
FROM JUIZ AS j
INNER JOIN AVALIACAO AS av
    ON av.id_juiz = j.id_juiz
INNER JOIN BATERIA AS b
    ON b.id_bateria = av.id_bateria
GROUP BY j.id_juiz, j.primeiro_nome, j.sobrenome
ORDER BY media_notas DESC, quantidade_avaliacoes DESC;
