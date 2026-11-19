-- =====================================================================
-- BiblioTech - Experiência Prática IV
-- Script 03: consultas (SELECT)
-- Data de referência do cenário: 2026-11-19. Para usar a data real do
-- servidor, troque '2026-11-19' por CURRENT_DATE.
-- =====================================================================

-- C1) Livros com a respectiva categoria (JOIN simples)
SELECT l.id_livro, l.titulo, l.ano_publicacao, c.nome AS categoria
FROM livro l
JOIN categoria c ON c.id_categoria = l.id_categoria
ORDER BY c.nome, l.titulo;

-- C2) Livros com seus autores (JOIN através da entidade associativa N:M)
SELECT l.titulo, a.nome AS autor
FROM livro l
JOIN livro_autor la ON la.id_livro = l.id_livro
JOIN autor a        ON a.id_autor  = la.id_autor
ORDER BY l.titulo, a.nome;

-- C3) Quantidade de exemplares disponíveis por livro
SELECT l.titulo, COUNT(e.id_exemplar) AS exemplares_disponiveis
FROM livro l
JOIN exemplar e ON e.id_livro = l.id_livro
WHERE e.status = 'disponivel'
GROUP BY l.id_livro, l.titulo
ORDER BY exemplares_disponiveis DESC, l.titulo;

-- C4) Empréstimos em aberto, com aluno, livro, funcionário e prazo
SELECT em.id_emprestimo,
       al.nome  AS aluno,
       l.titulo AS livro,
       fu.nome  AS atendente,
       em.data_emprestimo,
       em.data_prevista_devolucao
FROM emprestimo em
JOIN aluno al       ON al.id_aluno       = em.id_aluno
JOIN exemplar ex    ON ex.id_exemplar    = em.id_exemplar
JOIN livro l        ON l.id_livro        = ex.id_livro
JOIN funcionario fu ON fu.id_funcionario = em.id_funcionario
WHERE em.data_devolucao IS NULL
ORDER BY em.data_prevista_devolucao;

-- C5) Empréstimos em atraso na data de referência
SELECT em.id_emprestimo, al.nome AS aluno, al.email, l.titulo AS livro,
       em.data_prevista_devolucao
FROM emprestimo em
JOIN aluno al    ON al.id_aluno    = em.id_aluno
JOIN exemplar ex ON ex.id_exemplar = em.id_exemplar
JOIN livro l     ON l.id_livro     = ex.id_livro
WHERE em.data_devolucao IS NULL
  AND em.data_prevista_devolucao < '2026-11-19'
ORDER BY em.data_prevista_devolucao;

-- C6) Total de empréstimos por aluno, incluindo quem nunca emprestou (LEFT JOIN)
SELECT al.nome, al.situacao, COUNT(em.id_emprestimo) AS total_emprestimos
FROM aluno al
LEFT JOIN emprestimo em ON em.id_aluno = al.id_aluno
GROUP BY al.id_aluno, al.nome, al.situacao
ORDER BY total_emprestimos DESC, al.nome;

-- C7) Multas pendentes, com aluno, livro e valor
SELECT m.id_multa, al.nome AS aluno, l.titulo AS livro, m.valor, m.data_geracao
FROM multa m
JOIN emprestimo em ON em.id_emprestimo = m.id_emprestimo
JOIN aluno al      ON al.id_aluno      = em.id_aluno
JOIN exemplar ex   ON ex.id_exemplar   = em.id_exemplar
JOIN livro l       ON l.id_livro       = ex.id_livro
WHERE m.data_pagamento IS NULL;

-- C8) Livros mais emprestados (agregação por livro, via exemplar)
SELECT l.titulo, COUNT(em.id_emprestimo) AS vezes_emprestado
FROM livro l
JOIN exemplar ex   ON ex.id_livro    = l.id_livro
JOIN emprestimo em ON em.id_exemplar = ex.id_exemplar
GROUP BY l.id_livro, l.titulo
ORDER BY vezes_emprestado DESC, l.titulo;

-- C9) Livros que nunca foram emprestados (subconsulta com NOT EXISTS)
SELECT l.id_livro, l.titulo
FROM livro l
WHERE NOT EXISTS (
    SELECT 1
    FROM exemplar ex
    JOIN emprestimo em ON em.id_exemplar = ex.id_exemplar
    WHERE ex.id_livro = l.id_livro
);

-- C10) Reservas ativas, com aluno e livro
SELECT r.id_reserva, al.nome AS aluno, l.titulo AS livro, r.data_reserva
FROM reserva r
JOIN aluno al ON al.id_aluno = r.id_aluno
JOIN livro l  ON l.id_livro  = r.id_livro
WHERE r.status = 'ativa'
ORDER BY r.data_reserva;

-- C11) Os 3 livros mais emprestados (ORDER BY + LIMIT)
SELECT l.titulo, COUNT(em.id_emprestimo) AS vezes_emprestado
FROM livro l
JOIN exemplar ex   ON ex.id_livro    = l.id_livro
JOIN emprestimo em ON em.id_exemplar = ex.id_exemplar
GROUP BY l.id_livro, l.titulo
ORDER BY vezes_emprestado DESC, l.titulo
LIMIT 3;
