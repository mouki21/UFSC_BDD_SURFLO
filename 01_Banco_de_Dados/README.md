SURFLO 
=====================================

Arquivos
--------
01_criacao_bdd_SURFLO.sql
    Cria as tabelas, chaves, restrições, triggers e a view do ranking geral.

02_insertion_donnees_SURFLO.sql
    Insere os dados de teste para o novo cenário.

03_criar_banco.py
    Executa os dois scripts e cria surflo.db no mesmo diretório.

surflo.db
    Banco SQLite gerado e validado.

NOVAS DECISÕES DE MODELAGEM
---------------------------
- Um único campeonato.
- Cinco etapas, todas pertencentes ao mesmo campeonato.
- Cinco categorias com 16 atletas cada (80 atletas).
- Cada atleta pode se inscrever no máximo uma vez por etapa.
- 16 atletas por categoria/etapa.
- Quatro atletas e quatro juízes por bateria.
- Uma bateria só pode ser finalizada com exatamente 4 atletas, 4 juízes
  e 16 avaliações, ou seja, 4 notas por atleta.
- Cada nota deve estar entre 0 e 10.
- A pontuação da bateria é a soma das quatro notas (máximo 40).
- Os dois melhores de cada bateria classificatória e semifinal avançam.
- Os resultados de cada etapa são armazenados como pontos, sem publicar
  um ranking final separado por etapa.
- O ranking geral soma automaticamente os três melhores resultados
  entre as cinco etapas, por campeonato e categoria.
- Premiações apenas no ranking geral final, posições de 1 a 16.
- Pro homem e Pro mulher compartilham o mesmo catálogo de prêmios.
- Esperança homem e Esperança mulher compartilham o mesmo catálogo.
- Open misto tem seu próprio catálogo.
- Ingressos têm status DISPONIVEL, VENDIDO ou CANCELADO.
- A capacidade por etapa é controlada por trigger.
- Cada responsável de praia está associado à praia sob sua responsabilidade.
- A bateria só pode ser finalizada se houver autorização aprovada e válida
  para toda a duração da etapa.

DADOS DE TESTE
--------------
1 campeonato
5 etapas
5 categorias
80 atletas (16 por categoria)
400 inscrições (cada atleta nas 5 etapas)
175 baterias (7 por categoria/etapa)
700 participações em baterias
700 atribuições de juízes (4 por bateria)
2.800 avaliações (16 por bateria)
700 resultados individuais de bateria
400 resultados por atleta/etapa
80 linhas de classificação geral
48 tipos de prêmio (16 posições x 3 famílias)
80 atribuições de prêmios finais
250 ingressos (40 vendidos + 10 disponíveis por etapa)



