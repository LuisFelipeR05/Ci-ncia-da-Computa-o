-- =====================================================================
-- BiblioTech - Experiência Prática IV
-- Script 05: validação de erros de integridade e de tipo
-- Execute depois dos scripts 01 e 02 (o 04 não é necessário).
--
-- Cada instrução abaixo é INVÁLIDA de propósito e está comentada, para
-- não interromper a execução. Descomente UMA por vez, execute e leia a
-- mensagem do SGBD. Em todos os casos nada é gravado: o banco recusa o
-- comando inteiro.
-- =====================================================================

-- E1) Chave primária duplicada: já existe a categoria 1.
--     Correção: usar um id novo (por exemplo, 5).
-- INSERT INTO categoria (id_categoria, nome) VALUES (1, 'Física');

-- E2) Chave estrangeira inexistente: não há categoria 99.
--     Correção: cadastrar a categoria antes, ou usar uma existente.
-- INSERT INTO livro (id_livro, titulo, isbn, ano_publicacao, id_categoria)
-- VALUES (20, 'Livro Teste', '9788500000099', 2024, 99);

-- E3) Violação de NOT NULL: o título é obrigatório.
--     Correção: informar o título.
-- INSERT INTO livro (id_livro, titulo, isbn, ano_publicacao, id_categoria)
-- VALUES (21, NULL, '9788500000103', 2024, 1);

-- E4) Violação de UNIQUE: o e-mail já pertence à aluna Ana Souza.
--     Correção: usar um e-mail diferente.
-- INSERT INTO aluno (id_aluno, matricula, nome, email, telefone, situacao)
-- VALUES (7, 'RA2024007', 'Gabriel Torres', 'ana.souza@email.com', '(31) 90000-0007', 'ativo');

-- E5) Violação de CHECK: 'quebrado' não é um status permitido para exemplar.
--     Correção: usar disponivel, emprestado, manutencao ou perdido.
-- INSERT INTO exemplar (id_exemplar, codigo_patrimonio, status, id_livro)
-- VALUES (12, 'TOMBO-0012', 'quebrado', 1);

-- E6) Regra de negócio: a devolução prevista não pode ser anterior à data
--     do empréstimo (CHECK na tabela emprestimo).
-- INSERT INTO emprestimo
--     (id_emprestimo, data_emprestimo, data_prevista_devolucao, data_devolucao,
--      id_aluno, id_exemplar, id_funcionario, id_regra)
-- VALUES (11, '2026-11-19', '2026-11-10', NULL, 1, 1, 1, 1);

-- E7) Cardinalidade 1:0..1: o empréstimo 5 já tem multa (UNIQUE em
--     multa.id_emprestimo), então não aceita uma segunda.
-- INSERT INTO multa (id_multa, valor, data_geracao, data_pagamento, id_emprestimo)
-- VALUES (9, 5.00, '2026-11-19', NULL, 5);

-- E8) Erro de tipo: texto onde se espera uma data (DATE). MySQL (modo
--     estrito) e PostgreSQL recusam; a data deve vir no formato 'AAAA-MM-DD'.
-- INSERT INTO reserva (id_reserva, data_reserva, status, id_aluno, id_livro)
-- VALUES (9, 'ontem', 'ativa', 1, 1);

-- E9) Ordem de inserção: o empréstimo referencia aluno e exemplar, que
--     precisam existir antes. Aqui o aluno 999 não existe.
-- INSERT INTO emprestimo
--     (id_emprestimo, data_emprestimo, data_prevista_devolucao, data_devolucao,
--      id_aluno, id_exemplar, id_funcionario, id_regra)
-- VALUES (12, '2026-11-19', '2026-11-26', NULL, 999, 1, 1, 1);

-- Conferência: nenhuma das instruções acima deve ter gravado dados.
SELECT COUNT(*) AS total_categorias FROM categoria;   -- esperado: 4
SELECT COUNT(*) AS total_livros     FROM livro;       -- esperado: 8
