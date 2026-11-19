-- =====================================================================
-- BiblioTech - Consultas exploratórias (SELECT) - versão ampliada
-- Data de referência do cenário: 2026-11-19. Para usar a data do
-- servidor, troque '2026-11-19' por CURRENT_DATE.
-- Todas as consultas combinam JOIN, WHERE, ORDER BY e LIMIT.
-- =====================================================================

-- Q1) Painel de empréstimos em aberto, com a situação do prazo.
--     JOIN em 6 tabelas; CASE classifica cada empréstimo como ATRASADO,
--     VENCE HOJE ou NO PRAZO; WHERE considera apenas os não devolvidos
--     (data_devolucao NULL); os mais urgentes aparecem primeiro.
SELECT em.id_emprestimo,
       al.nome                    AS aluno,
       l.titulo                   AS livro,
       fu.nome                    AS atendente,
       r.descricao                AS regra_aplicada,
       em.data_prevista_devolucao AS vencimento,
       CASE
           WHEN em.data_prevista_devolucao <  '2026-11-19' THEN 'ATRASADO'
           WHEN em.data_prevista_devolucao =  '2026-11-19' THEN 'VENCE HOJE'
           ELSE 'NO PRAZO'
       END                        AS situacao_prazo
FROM emprestimo em
JOIN aluno al            ON al.id_aluno       = em.id_aluno
JOIN exemplar ex         ON ex.id_exemplar    = em.id_exemplar
JOIN livro l             ON l.id_livro        = ex.id_livro
JOIN funcionario fu      ON fu.id_funcionario = em.id_funcionario
JOIN regra_emprestimo r  ON r.id_regra        = em.id_regra
WHERE em.data_devolucao IS NULL
ORDER BY em.data_prevista_devolucao ASC, al.nome ASC
LIMIT 10;

-- Q2) Perfil de cada aluno: quantos empréstimos fez e quanto já foi
--     cobrado em multas.
--     LEFT JOIN mantém quem não tem multa (COALESCE troca NULL por 0);
--     COUNT(DISTINCT) e SUM agregam por aluno; HAVING descarta quem
--     nunca emprestou; WHERE restringe a alunos ativos ou suspensos.
SELECT al.nome,
       al.situacao,
       COUNT(DISTINCT em.id_emprestimo) AS total_emprestimos,
       COALESCE(SUM(m.valor), 0)        AS total_multas
FROM aluno al
LEFT JOIN emprestimo em ON em.id_aluno      = al.id_aluno
LEFT JOIN multa m       ON m.id_emprestimo  = em.id_emprestimo
WHERE al.situacao IN ('ativo', 'suspenso')
GROUP BY al.id_aluno, al.nome, al.situacao
HAVING COUNT(DISTINCT em.id_emprestimo) >= 1
ORDER BY total_multas DESC, total_emprestimos DESC, al.nome ASC
LIMIT 10;

-- Q3) Produtividade da equipe: empréstimos e ocorrências registrados
--     por funcionário.
--     Dois LEFT JOIN a partir de funcionario; COUNT(DISTINCT) evita
--     contar linhas repetidas pelo cruzamento; WHERE com LIKE filtra
--     o e-mail institucional.
SELECT fu.nome,
       fu.cargo,
       COUNT(DISTINCT em.id_emprestimo) AS emprestimos_registrados,
       COUNT(DISTINCT oc.id_ocorrencia) AS ocorrencias_registradas
FROM funcionario fu
LEFT JOIN emprestimo em ON em.id_funcionario = fu.id_funcionario
LEFT JOIN ocorrencia oc ON oc.id_funcionario = fu.id_funcionario
WHERE fu.email LIKE '%@bibliotech.edu'
GROUP BY fu.id_funcionario, fu.nome, fu.cargo
ORDER BY emprestimos_registrados DESC, fu.nome ASC
LIMIT 5;

-- Q4) Livros com exemplares fora da estante e a demanda por eles.
--     SUM(CASE ...) conta os exemplares disponíveis; a subconsulta
--     correlacionada conta as reservas ativas de cada livro; HAVING
--     mantém só os livros com pelo menos um exemplar indisponível;
--     WHERE restringe a três categorias (IN).
SELECT l.titulo,
       COUNT(ex.id_exemplar) AS total_exemplares,
       SUM(CASE WHEN ex.status = 'disponivel' THEN 1 ELSE 0 END) AS disponiveis,
       (SELECT COUNT(*)
          FROM reserva rs
         WHERE rs.id_livro = l.id_livro
           AND rs.status = 'ativa') AS reservas_ativas
FROM livro l
JOIN exemplar ex ON ex.id_livro = l.id_livro
WHERE l.id_categoria IN (1, 2, 4)
GROUP BY l.id_livro, l.titulo
HAVING SUM(CASE WHEN ex.status = 'disponivel' THEN 1 ELSE 0 END) < COUNT(ex.id_exemplar)
ORDER BY reservas_ativas DESC, disponiveis ASC, l.titulo ASC
LIMIT 5;

-- Q5) Detalhamento das multas geradas no período, com a situação de
--     pagamento e os dias de atraso equivalentes.
--     valor / multa_por_dia recupera os dias de atraso; CASE indica
--     PAGA ou PENDENTE; WHERE usa BETWEEN no período e filtra o valor.
SELECT m.id_multa,
       al.nome              AS aluno,
       l.titulo             AS livro,
       m.valor,
       m.valor / r.multa_por_dia AS dias_de_atraso,
       m.data_geracao,
       CASE WHEN m.data_pagamento IS NULL THEN 'PENDENTE' ELSE 'PAGA' END AS situacao_multa
FROM multa m
JOIN emprestimo em       ON em.id_emprestimo = m.id_emprestimo
JOIN aluno al            ON al.id_aluno      = em.id_aluno
JOIN exemplar ex         ON ex.id_exemplar   = em.id_exemplar
JOIN livro l             ON l.id_livro       = ex.id_livro
JOIN regra_emprestimo r  ON r.id_regra       = em.id_regra
WHERE m.data_geracao BETWEEN '2026-09-01' AND '2026-11-30'
  AND m.valor >= 10
ORDER BY m.valor DESC, m.data_geracao ASC
LIMIT 5;
