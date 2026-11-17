-- ============================================================
-- PROJETO SURFLO
-- Sistema de Gestão de Competições de Surf e Conservação Marinha
-- ============================================================
--
-- ARQUIVO: 01_criacao_bdd_SURFLO.sql
-- OBJETIVO:
-- Criar a estrutura da base de dados SURFLO utilizando SQLite.
--
-- ESTRUTURA DO PROJETO:
--   - 1 campeonato
--   - 5 etapas, realizadas em praias diferentes
--   - 5 categorias de competição
--   - Gestão de atletas, juízes, baterias e avaliações
--   - Gestão de resultados e classificações
--   - Gestão de ingressos e patrocínios
--   - Gestão de autorizações e ações ambientais
--
-- IMPLEMENTAÇÃO:
--   - Criação das tabelas e seus relacionamentos
--   - Definição das chaves primárias e estrangeiras
--   - Aplicação de restrições de integridade
--   - Criação de índices, views e triggers

PRAGMA foreign_keys = ON;

CREATE TABLE ENTIDADE_RESPONSAVEL (
 id_entidade INTEGER PRIMARY KEY,
 nome TEXT NOT NULL,
 tipo_entidade TEXT
);

CREATE TABLE CAMPEONATO (
 id_campeonato INTEGER PRIMARY KEY,
 nome TEXT NOT NULL,
 data_inicio TEXT NOT NULL,
 data_fim TEXT NOT NULL,
 id_entidade INTEGER NOT NULL,
 CHECK (data_fim >= data_inicio),
 FOREIGN KEY (id_entidade) REFERENCES ENTIDADE_RESPONSAVEL(id_entidade)
   ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE CATEGORIA (
 id_categoria INTEGER PRIMARY KEY,
 nome TEXT NOT NULL UNIQUE,
 familia_premiacao TEXT NOT NULL
   CHECK (familia_premiacao IN ('PRO','ESPERANCA','OPEN'))
);

CREATE TABLE PRAIA (
 id_praia INTEGER PRIMARY KEY,
 nome TEXT NOT NULL,
 cidade TEXT NOT NULL,
 estado TEXT NOT NULL
);

CREATE TABLE RESPONSAVEL_PRAIA (
 id_responsavel_praia INTEGER PRIMARY KEY,
 primeiro_nome TEXT NOT NULL,
 sobrenome TEXT NOT NULL,
 id_entidade INTEGER NOT NULL,
 id_praia INTEGER NOT NULL,
 FOREIGN KEY (id_entidade) REFERENCES ENTIDADE_RESPONSAVEL(id_entidade),
 FOREIGN KEY (id_praia) REFERENCES PRAIA(id_praia),
 UNIQUE(id_responsavel_praia, id_praia)
);

CREATE TABLE ATLETA (
 id_atleta INTEGER PRIMARY KEY,
 primeiro_nome TEXT NOT NULL,
 sobrenome TEXT NOT NULL,
 data_nascimento TEXT,
 pais_origem TEXT NOT NULL DEFAULT 'Brasil',
 id_categoria INTEGER NOT NULL,
 FOREIGN KEY (id_categoria) REFERENCES CATEGORIA(id_categoria),
 UNIQUE(id_atleta, id_categoria)
);

CREATE TABLE JUIZ (
 id_juiz INTEGER PRIMARY KEY,
 primeiro_nome TEXT NOT NULL,
 sobrenome TEXT NOT NULL
);

CREATE TABLE SPONSOR (
 id_sponsor INTEGER PRIMARY KEY,
 nome TEXT NOT NULL,
 email TEXT UNIQUE,
 telefone TEXT,
 site TEXT
);

CREATE TABLE CLIENTE (
 id_cliente INTEGER PRIMARY KEY,
 primeiro_nome TEXT NOT NULL,
 sobrenome TEXT NOT NULL,
 email TEXT UNIQUE,
 telefone TEXT
);

CREATE TABLE VOLUNTARIO (
 id_voluntario INTEGER PRIMARY KEY,
 primeiro_nome TEXT NOT NULL,
 sobrenome TEXT NOT NULL
);

CREATE TABLE CAMPEONATO_CATEGORIA (
 id_campeonato INTEGER NOT NULL,
 id_categoria INTEGER NOT NULL,
 PRIMARY KEY(id_campeonato,id_categoria),
 FOREIGN KEY(id_campeonato) REFERENCES CAMPEONATO(id_campeonato) ON DELETE CASCADE,
 FOREIGN KEY(id_categoria) REFERENCES CATEGORIA(id_categoria) ON DELETE RESTRICT
);

CREATE TABLE ETAPA (
 id_etapa INTEGER PRIMARY KEY,
 nome TEXT NOT NULL,
 data_inicio TEXT NOT NULL,
 data_fim TEXT NOT NULL,
 capacidade INTEGER NOT NULL CHECK(capacidade > 0),
 id_praia INTEGER NOT NULL,
 id_campeonato INTEGER NOT NULL,
 CHECK(data_fim >= data_inicio),
 FOREIGN KEY(id_praia) REFERENCES PRAIA(id_praia),
 FOREIGN KEY(id_campeonato) REFERENCES CAMPEONATO(id_campeonato) ON DELETE CASCADE
);

CREATE TABLE ETAPA_CATEGORIA (
 id_etapa INTEGER NOT NULL,
 id_categoria INTEGER NOT NULL,
 PRIMARY KEY(id_etapa,id_categoria),
 FOREIGN KEY(id_etapa) REFERENCES ETAPA(id_etapa) ON DELETE CASCADE,
 FOREIGN KEY(id_categoria) REFERENCES CATEGORIA(id_categoria)
);

CREATE TABLE INSCRICAO (
 id_inscricao INTEGER PRIMARY KEY,
 id_atleta INTEGER NOT NULL,
 id_etapa INTEGER NOT NULL,
 id_categoria INTEGER NOT NULL,
 data_inscricao TEXT NOT NULL,
 UNIQUE(id_atleta,id_etapa),
 FOREIGN KEY(id_atleta,id_categoria) REFERENCES ATLETA(id_atleta,id_categoria),
 FOREIGN KEY(id_etapa,id_categoria) REFERENCES ETAPA_CATEGORIA(id_etapa,id_categoria)
);

CREATE TABLE BATERIA (
 id_bateria INTEGER PRIMARY KEY,
 fase TEXT NOT NULL CHECK(fase IN ('CLASSIFICATORIA','SEMIFINAL','FINAL')),
 numero_bateria INTEGER NOT NULL,
 data_hora TEXT,
 status TEXT NOT NULL DEFAULT 'EM_FORMACAO'
   CHECK(status IN ('EM_FORMACAO','FINALIZADA')),
 id_etapa INTEGER NOT NULL,
 id_categoria INTEGER NOT NULL,
 UNIQUE(id_etapa,id_categoria,fase,numero_bateria),
 FOREIGN KEY(id_etapa,id_categoria) REFERENCES ETAPA_CATEGORIA(id_etapa,id_categoria)
   ON DELETE CASCADE
);

CREATE TABLE JUIZ_BATERIA (
 id_juiz INTEGER NOT NULL,
 id_bateria INTEGER NOT NULL,
 PRIMARY KEY(id_juiz,id_bateria),
 FOREIGN KEY(id_juiz) REFERENCES JUIZ(id_juiz),
 FOREIGN KEY(id_bateria) REFERENCES BATERIA(id_bateria) ON DELETE CASCADE
);

CREATE TABLE PARTICIPACAO_BATERIA (
 id_participacao_bateria INTEGER PRIMARY KEY,
 id_atleta INTEGER NOT NULL,
 id_bateria INTEGER NOT NULL,
 UNIQUE(id_atleta,id_bateria),
 UNIQUE(id_participacao_bateria,id_bateria),
 FOREIGN KEY(id_atleta) REFERENCES ATLETA(id_atleta),
 FOREIGN KEY(id_bateria) REFERENCES BATERIA(id_bateria) ON DELETE CASCADE
);

CREATE TABLE AVALIACAO (
 id_avaliacao INTEGER PRIMARY KEY,
 id_participacao_bateria INTEGER NOT NULL,
 id_bateria INTEGER NOT NULL,
 id_juiz INTEGER NOT NULL,
 nota REAL NOT NULL CHECK(nota BETWEEN 0 AND 10),
 UNIQUE(id_participacao_bateria,id_juiz),
 FOREIGN KEY(id_participacao_bateria,id_bateria)
   REFERENCES PARTICIPACAO_BATERIA(id_participacao_bateria,id_bateria) ON DELETE CASCADE,
 FOREIGN KEY(id_juiz,id_bateria)
   REFERENCES JUIZ_BATERIA(id_juiz,id_bateria) ON DELETE CASCADE
);

CREATE TABLE RESULTADO_BATERIA (
 id_participacao_bateria INTEGER PRIMARY KEY,
 id_bateria INTEGER NOT NULL,
 pontuacao_total REAL NOT NULL CHECK(pontuacao_total BETWEEN 0 AND 40),
 posicao_bateria INTEGER NOT NULL CHECK(posicao_bateria BETWEEN 1 AND 4),
 qualificado INTEGER NOT NULL CHECK(qualificado IN (0,1)),
 FOREIGN KEY(id_participacao_bateria,id_bateria)
   REFERENCES PARTICIPACAO_BATERIA(id_participacao_bateria,id_bateria) ON DELETE CASCADE
);

CREATE TABLE RESULTADO_ETAPA (
 id_resultado_etapa INTEGER PRIMARY KEY,
 id_atleta INTEGER NOT NULL,
 id_etapa INTEGER NOT NULL,
 id_categoria INTEGER NOT NULL,
 pontos_obtidos INTEGER NOT NULL CHECK(pontos_obtidos >= 0),
 UNIQUE(id_atleta,id_etapa),
 FOREIGN KEY(id_atleta,id_categoria) REFERENCES ATLETA(id_atleta,id_categoria),
 FOREIGN KEY(id_etapa,id_categoria) REFERENCES ETAPA_CATEGORIA(id_etapa,id_categoria)
);

CREATE TABLE CLASSIFICACAO_GERAL (
 id_classificacao_geral INTEGER PRIMARY KEY,
 id_campeonato INTEGER NOT NULL,
 id_categoria INTEGER NOT NULL,
 id_atleta INTEGER NOT NULL,
 pontuacao_total INTEGER NOT NULL DEFAULT 0 CHECK(pontuacao_total >= 0),
 quantidade_resultados_contabilizados INTEGER NOT NULL DEFAULT 0
   CHECK(quantidade_resultados_contabilizados BETWEEN 0 AND 3),
 posicao_geral INTEGER CHECK(posicao_geral IS NULL OR posicao_geral > 0),
 UNIQUE(id_campeonato,id_categoria,id_atleta),
 FOREIGN KEY(id_campeonato,id_categoria) REFERENCES CAMPEONATO_CATEGORIA(id_campeonato,id_categoria),
 FOREIGN KEY(id_atleta,id_categoria) REFERENCES ATLETA(id_atleta,id_categoria)
);

CREATE TABLE PREMIACAO (
 id_premiacao INTEGER PRIMARY KEY,
 familia_categoria TEXT NOT NULL CHECK(familia_categoria IN ('PRO','ESPERANCA','OPEN')),
 posicao_geral INTEGER NOT NULL CHECK(posicao_geral BETWEEN 1 AND 16),
 nome TEXT NOT NULL,
 valor REAL NOT NULL DEFAULT 0 CHECK(valor >= 0),
 UNIQUE(familia_categoria,posicao_geral)
);

CREATE TABLE ATRIBUICAO_PREMIACAO (
 id_atribuicao INTEGER PRIMARY KEY,
 id_premiacao INTEGER NOT NULL,
 id_classificacao_geral INTEGER NOT NULL UNIQUE,
 FOREIGN KEY(id_premiacao) REFERENCES PREMIACAO(id_premiacao),
 FOREIGN KEY(id_classificacao_geral) REFERENCES CLASSIFICACAO_GERAL(id_classificacao_geral)
);

CREATE TABLE CONTRATO_PATROCINIO (
 id_sponsor INTEGER NOT NULL,
 id_campeonato INTEGER NOT NULL,
 valor_patrocinio REAL NOT NULL DEFAULT 0 CHECK(valor_patrocinio >= 0),
 data_inicio TEXT,
 data_fim TEXT,
 tipo_patrocinio TEXT NOT NULL,
 PRIMARY KEY(id_sponsor,id_campeonato),
 CHECK(data_fim IS NULL OR data_inicio IS NULL OR data_fim >= data_inicio),
 FOREIGN KEY(id_sponsor) REFERENCES SPONSOR(id_sponsor),
 FOREIGN KEY(id_campeonato) REFERENCES CAMPEONATO(id_campeonato)
);

CREATE TABLE INGRESSO (
 id_ingresso INTEGER PRIMARY KEY,
 id_cliente INTEGER,
 id_etapa INTEGER NOT NULL,
 preco REAL NOT NULL CHECK(preco >= 0),
 data_compra TEXT NOT NULL,
 status TEXT NOT NULL DEFAULT 'DISPONIVEL'
   CHECK(status IN ('DISPONIVEL','VENDIDO','CANCELADO')),
 FOREIGN KEY(id_cliente) REFERENCES CLIENTE(id_cliente) ON DELETE SET NULL,
 FOREIGN KEY(id_etapa) REFERENCES ETAPA(id_etapa) ON DELETE CASCADE,
 CHECK((status='VENDIDO' AND id_cliente IS NOT NULL) OR status<>'VENDIDO')
);

CREATE TABLE AUTORIZACAO (
 id_autorizacao INTEGER PRIMARY KEY,
 id_responsavel_praia INTEGER NOT NULL,
 id_praia INTEGER NOT NULL,
 id_etapa INTEGER NOT NULL UNIQUE,
 status TEXT NOT NULL CHECK(status IN ('PENDENTE','APROVADA','RECUSADA','EXPIRADA')),
 data_solicitacao TEXT NOT NULL,
 data_decisao TEXT,
 data_inicio_validade TEXT,
 data_fim_validade TEXT,
 FOREIGN KEY(id_responsavel_praia,id_praia)
   REFERENCES RESPONSAVEL_PRAIA(id_responsavel_praia,id_praia),
 FOREIGN KEY(id_etapa) REFERENCES ETAPA(id_etapa) ON DELETE CASCADE,
 CHECK(data_fim_validade IS NULL OR data_inicio_validade IS NULL OR data_fim_validade>=data_inicio_validade)
);

CREATE TABLE ACAO_AMBIENTAL (
 id_acao_ambiental INTEGER PRIMARY KEY,
 descricao TEXT NOT NULL,
 data_acao TEXT NOT NULL,
 tipo_acao TEXT NOT NULL,
 id_praia INTEGER NOT NULL,
 FOREIGN KEY(id_praia) REFERENCES PRAIA(id_praia)
);

CREATE TABLE PARTICIPACAO_ACAO (
 id_voluntario INTEGER NOT NULL,
 id_acao_ambiental INTEGER NOT NULL,
 PRIMARY KEY(id_voluntario,id_acao_ambiental),
 FOREIGN KEY(id_voluntario) REFERENCES VOLUNTARIO(id_voluntario) ON DELETE CASCADE,
 FOREIGN KEY(id_acao_ambiental) REFERENCES ACAO_AMBIENTAL(id_acao_ambiental) ON DELETE CASCADE
);

-- Triggers: máximo de quatro atletas por bateria.
CREATE TRIGGER trg_participacao_max4_insert
BEFORE INSERT ON PARTICIPACAO_BATERIA
WHEN (SELECT status FROM BATERIA WHERE id_bateria=NEW.id_bateria)='FINALIZADA'
  OR (SELECT COUNT(*) FROM PARTICIPACAO_BATERIA WHERE id_bateria=NEW.id_bateria)>=4
BEGIN SELECT RAISE(ABORT,'Bateria finalizada ou limite de 4 atletas atingido'); END;

CREATE TRIGGER trg_participacao_max4_update
BEFORE UPDATE OF id_bateria ON PARTICIPACAO_BATERIA
WHEN NEW.id_bateria<>OLD.id_bateria AND (
  (SELECT status FROM BATERIA WHERE id_bateria=NEW.id_bateria)='FINALIZADA'
  OR (SELECT COUNT(*) FROM PARTICIPACAO_BATERIA WHERE id_bateria=NEW.id_bateria)>=4)
BEGIN SELECT RAISE(ABORT,'Bateria finalizada ou limite de 4 atletas atingido'); END;

-- Máximo de quatro juízes por bateria.
CREATE TRIGGER trg_juiz_max4_insert
BEFORE INSERT ON JUIZ_BATERIA
WHEN (SELECT status FROM BATERIA WHERE id_bateria=NEW.id_bateria)='FINALIZADA'
  OR (SELECT COUNT(*) FROM JUIZ_BATERIA WHERE id_bateria=NEW.id_bateria)>=4
BEGIN SELECT RAISE(ABORT,'Bateria finalizada ou limite de 4 juizes atingido'); END;

-- Não permitir avaliações após finalização.
CREATE TRIGGER trg_avaliacao_bateria_aberta
BEFORE INSERT ON AVALIACAO
WHEN (SELECT status FROM BATERIA WHERE id_bateria=NEW.id_bateria)='FINALIZADA'
BEGIN SELECT RAISE(ABORT,'Nao e possivel avaliar uma bateria finalizada'); END;

-- Validação de completude e geração automática do resultado da bateria.
CREATE TRIGGER trg_finalizar_bateria
BEFORE UPDATE OF status ON BATERIA
WHEN OLD.status='EM_FORMACAO' AND NEW.status='FINALIZADA'
BEGIN
 SELECT CASE WHEN (SELECT COUNT(*) FROM PARTICIPACAO_BATERIA WHERE id_bateria=NEW.id_bateria)<>4
   THEN RAISE(ABORT,'A bateria precisa ter exatamente 4 atletas') END;
 SELECT CASE WHEN (SELECT COUNT(*) FROM JUIZ_BATERIA WHERE id_bateria=NEW.id_bateria)<>4
   THEN RAISE(ABORT,'A bateria precisa ter exatamente 4 juizes') END;
 SELECT CASE WHEN (SELECT COUNT(*) FROM AVALIACAO WHERE id_bateria=NEW.id_bateria)<>16
   THEN RAISE(ABORT,'A bateria precisa ter exatamente 16 avaliacoes') END;
 SELECT CASE WHEN EXISTS(
   SELECT 1 FROM PARTICIPACAO_BATERIA pb
   LEFT JOIN AVALIACAO a ON a.id_participacao_bateria=pb.id_participacao_bateria
   WHERE pb.id_bateria=NEW.id_bateria
   GROUP BY pb.id_participacao_bateria HAVING COUNT(a.id_avaliacao)<>4)
   THEN RAISE(ABORT,'Cada atleta precisa receber 4 notas') END;
END;

CREATE TRIGGER trg_resultado_bateria_apos_finalizacao
AFTER UPDATE OF status ON BATERIA
WHEN OLD.status='EM_FORMACAO' AND NEW.status='FINALIZADA'
BEGIN
 INSERT INTO RESULTADO_BATERIA(id_participacao_bateria,id_bateria,pontuacao_total,posicao_bateria,qualificado)
 SELECT id_participacao_bateria,id_bateria,pontuacao_total,posicao_bateria,
        CASE WHEN NEW.fase='FINAL' THEN 0 WHEN posicao_bateria<=2 THEN 1 ELSE 0 END
 FROM (
   SELECT pb.id_participacao_bateria,pb.id_bateria,
          ROUND(SUM(a.nota),2) AS pontuacao_total,
          ROW_NUMBER() OVER (ORDER BY SUM(a.nota) DESC,pb.id_participacao_bateria) AS posicao_bateria
   FROM PARTICIPACAO_BATERIA pb
   JOIN AVALIACAO a ON a.id_participacao_bateria=pb.id_participacao_bateria
   WHERE pb.id_bateria=NEW.id_bateria
   GROUP BY pb.id_participacao_bateria,pb.id_bateria
 );
END;

-- Nenhuma bateria pode ser finalizada sem autorização aprovada e válida para a etapa.
CREATE TRIGGER trg_bateria_exige_autorizacao_valida
BEFORE UPDATE OF status ON BATERIA
WHEN OLD.status='EM_FORMACAO' AND NEW.status='FINALIZADA'
 AND NOT EXISTS (
   SELECT 1
   FROM ETAPA e
   JOIN AUTORIZACAO au ON au.id_etapa=e.id_etapa
   WHERE e.id_etapa=NEW.id_etapa
     AND au.id_praia=e.id_praia
     AND au.status='APROVADA'
     AND au.data_inicio_validade<=e.data_inicio
     AND au.data_fim_validade>=e.data_fim
 )
BEGIN
 SELECT RAISE(ABORT,'A etapa precisa de autorizacao aprovada e valida para toda a sua duracao');
END;

-- Capacidade: cada venda deve respeitar a capacidade da etapa.
CREATE TRIGGER trg_ingresso_capacidade_insert
BEFORE INSERT ON INGRESSO
WHEN NEW.status='VENDIDO' AND
 (SELECT COUNT(*) FROM INGRESSO WHERE id_etapa=NEW.id_etapa AND status='VENDIDO') >=
 (SELECT capacidade FROM ETAPA WHERE id_etapa=NEW.id_etapa)
BEGIN SELECT RAISE(ABORT,'Capacidade de ingressos da etapa atingida'); END;

CREATE TRIGGER trg_ingresso_capacidade_update
BEFORE UPDATE OF status,id_etapa ON INGRESSO
WHEN NEW.status='VENDIDO' AND
 (SELECT COUNT(*) FROM INGRESSO WHERE id_etapa=NEW.id_etapa AND status='VENDIDO'
   AND id_ingresso<>OLD.id_ingresso) >=
 (SELECT capacidade FROM ETAPA WHERE id_etapa=NEW.id_etapa)
BEGIN SELECT RAISE(ABORT,'Capacidade de ingressos da etapa atingida'); END;

CREATE TRIGGER trg_autorizacao_plage_etapa
BEFORE INSERT ON AUTORIZACAO
WHEN (SELECT id_praia FROM ETAPA WHERE id_etapa=NEW.id_etapa)<>NEW.id_praia
BEGIN SELECT RAISE(ABORT,'A autorizacao deve corresponder a praia da etapa'); END;

CREATE TRIGGER trg_autorizacao_valida_etapa
BEFORE UPDATE OF status ON AUTORIZACAO
WHEN NEW.status='APROVADA' AND (
 NEW.data_inicio_validade IS NULL OR NEW.data_fim_validade IS NULL
 OR NEW.data_inicio_validade>(SELECT data_inicio FROM ETAPA WHERE id_etapa=NEW.id_etapa)
 OR NEW.data_fim_validade<(SELECT data_fim FROM ETAPA WHERE id_etapa=NEW.id_etapa))
BEGIN SELECT RAISE(ABORT,'A autorizacao deve cobrir todo o periodo da etapa'); END;

CREATE VIEW VW_CLASSIFICACAO_GERAL_CALCULADA AS
WITH pontuacoes AS (
 SELECT re.id_atleta,re.id_categoria,e.id_campeonato,re.pontos_obtidos,
        ROW_NUMBER() OVER (
          PARTITION BY re.id_atleta,re.id_categoria,e.id_campeonato
          ORDER BY re.pontos_obtidos DESC,re.id_etapa
        ) AS ordem
 FROM RESULTADO_ETAPA re
 JOIN ETAPA e ON e.id_etapa=re.id_etapa
),
totais AS (
 SELECT id_atleta,id_categoria,id_campeonato,
        SUM(pontos_obtidos) AS pontuacao_total,
        COUNT(*) AS quantidade_resultados_contabilizados
 FROM pontuacoes WHERE ordem<=3
 GROUP BY id_atleta,id_categoria,id_campeonato
)
SELECT t.id_campeonato,t.id_categoria,t.id_atleta,t.pontuacao_total,
       t.quantidade_resultados_contabilizados,
       ROW_NUMBER() OVER(PARTITION BY t.id_campeonato,t.id_categoria
                          ORDER BY t.pontuacao_total DESC,t.id_atleta ASC) AS posicao_geral
FROM totais t;

CREATE INDEX idx_etapa_campeonato ON ETAPA(id_campeonato);
CREATE INDEX idx_inscricao_atleta_etapa ON INSCRICAO(id_atleta,id_etapa);
CREATE INDEX idx_bateria_etapa_categoria ON BATERIA(id_etapa,id_categoria);
CREATE INDEX idx_participacao_bateria ON PARTICIPACAO_BATERIA(id_bateria);
CREATE INDEX idx_resultado_etapa ON RESULTADO_ETAPA(id_etapa,id_categoria);
CREATE INDEX idx_ingresso_etapa_status ON INGRESSO(id_etapa,status);
