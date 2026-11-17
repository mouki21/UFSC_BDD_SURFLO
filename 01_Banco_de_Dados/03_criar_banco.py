from pathlib import Path
import sqlite3

HERE = Path(__file__).resolve().parent
DDL = HERE / "01_criacao_bdd_SURFLO.sql"
DML = HERE / "02_insertion_donnees_SURFLO.sql"
DB = HERE / "surflo_nova.db"

def main():
    if DB.exists():
        DB.unlink()  # only replaces the generated project database in this folder
    conn = sqlite3.connect(DB)
    try:
        conn.execute("PRAGMA foreign_keys = ON")
        conn.executescript(DDL.read_text(encoding="utf-8"))
        conn.executescript(DML.read_text(encoding="utf-8"))
        fk_errors = conn.execute("PRAGMA foreign_key_check").fetchall()
        integrity = conn.execute("PRAGMA integrity_check").fetchone()[0]
        if fk_errors or integrity != "ok":
            raise RuntimeError(f"Database validation failed: FK={fk_errors}, integrity={integrity}")
        print(f"Database created: {DB}")
        print(f"SQLite version: {sqlite3.sqlite_version}")
        for table in (
            "CAMPEONATO", "ETAPA", "CATEGORIA", "ATLETA", "INSCRICAO",
            "BATERIA", "PARTICIPACAO_BATERIA", "JUIZ_BATERIA", "AVALIACAO",
            "RESULTADO_BATERIA", "RESULTADO_ETAPA", "CLASSIFICACAO_GERAL",
            "PREMIACAO", "ATRIBUICAO_PREMIACAO", "INGRESSO"
        ):
            count = conn.execute(f'SELECT COUNT(*) FROM "{table}"').fetchone()[0]
            print(f"{table}: {count}")
        print("Integrity check: OK")
        print("Foreign key check: OK")
        print("Global ranking (top 10):")
        rows = conn.execute("""
            SELECT c.nome, a.primeiro_nome, a.sobrenome,
                   g.pontuacao_total, g.quantidade_resultados_contabilizados,
                   g.posicao_geral
            FROM VW_CLASSIFICACAO_GERAL_CALCULADA g
            JOIN ATLETA a ON a.id_atleta=g.id_atleta
            JOIN CATEGORIA c ON c.id_categoria=g.id_categoria
            ORDER BY c.id_categoria, g.posicao_geral
            LIMIT 10
        """).fetchall()
        for row in rows:
            print(row)
    finally:
        conn.close()

if __name__ == "__main__":
    main()
