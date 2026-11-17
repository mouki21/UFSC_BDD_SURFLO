-- CONSULTA 10 — Demonstração de transações, SAVEPOINT, ROLLBACK e COMMIT
-- Objetivo: demonstrar controle transacional sem modificar tabelas permanentes.
-- Todas as operações são feitas em uma tabela TEMPORARIA, removida ao final.
-- O roteiro inclui dois SAVEPOINTs, dois ROLLBACK TO, dois COMMITs e um ROLLBACK integral.

DROP TABLE IF EXISTS temp.teste_transacao_surflo;
CREATE TEMP TABLE teste_transacao_surflo (
    id INTEGER PRIMARY KEY,
    descricao TEXT NOT NULL,
    valor INTEGER NOT NULL
);

-- Transação 1: o valor alterado depois do SAVEPOINT é desfeito; a inserção inicial é confirmada.
BEGIN TRANSACTION;
INSERT INTO teste_transacao_surflo VALUES (1, 'Registro confirmado na transacao 1', 100);
SAVEPOINT ponto_1;
UPDATE teste_transacao_surflo
SET valor = 999
WHERE id = 1;
ROLLBACK TO SAVEPOINT ponto_1;
RELEASE SAVEPOINT ponto_1;
COMMIT;

-- Transação 2: a segunda inserção é desfeita até o SAVEPOINT; a primeira é confirmada.
BEGIN TRANSACTION;
INSERT INTO teste_transacao_surflo VALUES (2, 'Registro confirmado na transacao 2', 200);
SAVEPOINT ponto_2;
INSERT INTO teste_transacao_surflo VALUES (3, 'Registro desfeito pelo savepoint', 300);
ROLLBACK TO SAVEPOINT ponto_2;
RELEASE SAVEPOINT ponto_2;
COMMIT;

-- Transação 3: demonstra ROLLBACK integral de uma transação.
BEGIN TRANSACTION;
INSERT INTO teste_transacao_surflo VALUES (4, 'Registro desfeito pelo rollback integral', 400);
ROLLBACK;

-- Resultado esperado: somente os registros 1 e 2 permanecem na tabela temporária.
SELECT id, descricao, valor
FROM teste_transacao_surflo
ORDER BY id ASC;

DROP TABLE temp.teste_transacao_surflo;
