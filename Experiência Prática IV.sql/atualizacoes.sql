-- =====================================================================
-- BiblioTech - Experiência Prática IV
-- Script 04: atualização de registros (UPDATE)
-- Todas as instruções usam WHERE para atingir apenas o registro desejado.
-- Execute na ordem: U2 depende de U1, e U4 depende de U3.
-- Data de referência do cenário: 2026-11-19.
-- =====================================================================

-- U1) Registra a devolução do empréstimo 6 (estava em aberto e atrasado).
--     A condição "data_devolucao IS NULL" impede alterar um empréstimo
--     que já foi devolvido.
UPDATE emprestimo
SET    data_devolucao = '2026-11-19'
WHERE  id_emprestimo = 6
  AND  data_devolucao IS NULL;

-- U2) Libera o exemplar 2 depois da devolução, mudando seu status para
--     'disponivel'. A subconsulta garante que ele só seja liberado se
--     não restar nenhum empréstimo em aberto para esse exemplar.
UPDATE exemplar
SET    status = 'disponivel'
WHERE  id_exemplar = 2
  AND  NOT EXISTS (
         SELECT 1
         FROM   emprestimo em
         WHERE  em.id_exemplar = 2
           AND  em.data_devolucao IS NULL
       );

-- U3) Registra o pagamento da multa 2, que estava pendente.
--     "data_pagamento IS NULL" evita sobrescrever um pagamento anterior.
UPDATE multa
SET    data_pagamento = '2026-11-19'
WHERE  id_multa = 2
  AND  data_pagamento IS NULL;

-- U4) Reativa o aluno 4 (suspenso por multa), mas somente se ele não tiver
--     nenhuma outra multa pendente.
UPDATE aluno
SET    situacao = 'ativo'
WHERE  id_aluno = 4
  AND  situacao = 'suspenso'
  AND  NOT EXISTS (
         SELECT 1
         FROM   multa m
         JOIN   emprestimo em ON em.id_emprestimo = m.id_emprestimo
         WHERE  em.id_aluno = 4
           AND  m.data_pagamento IS NULL
       );

-- U5) Renova o empréstimo 8 por mais 7 dias (novo vencimento: 26/11/2026),
--     desde que ele ainda esteja em aberto.
UPDATE emprestimo
SET    data_prevista_devolucao = '2026-11-26'
WHERE  id_emprestimo = 8
  AND  data_devolucao IS NULL;

-- U6) Expira as reservas ativas feitas antes de 04/11/2026.
--     (No MySQL Workbench, se o modo "safe updates" bloquear este comando
--     por não usar a chave primária no WHERE, execute antes:
--     SET SQL_SAFE_UPDATES = 0;)
UPDATE reserva
SET    status = 'expirada'
WHERE  status = 'ativa'
  AND  data_reserva < '2026-11-04';

-- Conferência dos resultados
SELECT id_emprestimo, data_devolucao, data_prevista_devolucao
FROM   emprestimo WHERE id_emprestimo IN (6, 8);
SELECT id_exemplar, status FROM exemplar WHERE id_exemplar = 2;
SELECT id_multa, data_pagamento FROM multa WHERE id_multa = 2;
SELECT id_aluno, situacao FROM aluno WHERE id_aluno = 4;
SELECT id_reserva, status FROM reserva ORDER BY id_reserva;
