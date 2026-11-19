-- =====================================================================
-- BiblioTech - Experiência Prática IV
-- Script 02: povoamento das tabelas (INSERT)
-- Todos os dados são fictícios. A ordem respeita a integridade
-- referencial: primeiro as tabelas independentes, depois as que
-- possuem chave estrangeira.
-- Data de referência do cenário: 2026-11-19.
-- =====================================================================

-- 1) Tabelas independentes ---------------------------------------------

INSERT INTO categoria (id_categoria, nome) VALUES
    (1, 'Computação'),
    (2, 'Literatura'),
    (3, 'Matemática'),
    (4, 'História');

INSERT INTO autor (id_autor, nome, nacionalidade) VALUES
    (1, 'Thomas H. Cormen',        'Americana'),
    (2, 'Brian W. Kernighan',      'Canadense'),
    (3, 'Dennis M. Ritchie',       'Americana'),
    (4, 'Abraham Silberschatz',    'Americana'),
    (5, 'Machado de Assis',        'Brasileira'),
    (6, 'Clarice Lispector',       'Brasileira'),
    (7, 'Sérgio Buarque de Holanda', 'Brasileira'),
    (8, 'Helena Barbosa',          'Brasileira');

INSERT INTO aluno (id_aluno, matricula, nome, email, telefone, situacao) VALUES
    (1, 'RA2024001', 'Ana Souza',    'ana.souza@email.com',    '(31) 90000-0001', 'ativo'),
    (2, 'RA2024002', 'Bruno Lima',   'bruno.lima@email.com',   '(31) 90000-0002', 'ativo'),
    (3, 'RA2024003', 'Carla Mendes', 'carla.mendes@email.com', '(31) 90000-0003', 'ativo'),
    (4, 'RA2024004', 'Diego Alves',  'diego.alves@email.com',  '(31) 90000-0004', 'suspenso'),
    (5, 'RA2024005', 'Elisa Rocha',  'elisa.rocha@email.com',  '(31) 90000-0005', 'ativo'),
    (6, 'RA2024006', 'Felipe Costa', 'felipe.costa@email.com', '(31) 90000-0006', 'ativo');

INSERT INTO funcionario (id_funcionario, nome, cargo, email) VALUES
    (1, 'Marcos Pereira',  'Bibliotecário', 'marcos.pereira@bibliotech.edu'),
    (2, 'Juliana Nunes',   'Atendente',     'juliana.nunes@bibliotech.edu'),
    (3, 'Roberto Dias',    'Coordenador',   'roberto.dias@bibliotech.edu');

INSERT INTO regra_emprestimo (id_regra, descricao, prazo_dias, limite_renovacoes, multa_por_dia) VALUES
    (1, 'Graduação - padrão',          7, 2, 1.50),
    (2, 'Consulta rápida',             3, 0, 3.00),
    (3, 'Pós-graduação',              14, 3, 1.00);

-- 2) Livros e relacionamentos ------------------------------------------
-- Os ISBNs são fictícios, apenas ilustrativos.

INSERT INTO livro (id_livro, titulo, isbn, ano_publicacao, id_categoria) VALUES
    (1, 'Algoritmos: Teoria e Prática',            '9788500000011', 2012, 1),
    (2, 'A Linguagem de Programação C',            '9788500000028', 1989, 1),
    (3, 'Sistemas de Banco de Dados',              '9788500000035', 2020, 1),
    (4, 'Dom Casmurro',                            '9788500000042', 1899, 2),
    (5, 'Memórias Póstumas de Brás Cubas',         '9788500000059', 1881, 2),
    (6, 'A Hora da Estrela',                       '9788500000066', 1977, 2),
    (7, 'Raízes do Brasil',                        '9788500000073', 1936, 4),
    (8, 'Estruturas de Dados em C',                '9788500000080', 2023, 1);

INSERT INTO livro_autor (id_livro, id_autor) VALUES
    (1, 1),
    (2, 2),
    (2, 3),   -- livro com dois autores (N:M)
    (3, 4),
    (4, 5),
    (5, 5),   -- autor com dois livros (N:M)
    (6, 6),
    (7, 7),
    (8, 8);

INSERT INTO exemplar (id_exemplar, codigo_patrimonio, status, id_livro) VALUES
    (1,  'TOMBO-0001', 'disponivel', 1),
    (2,  'TOMBO-0002', 'emprestado', 1),
    (3,  'TOMBO-0003', 'emprestado', 2),
    (4,  'TOMBO-0004', 'disponivel', 3),
    (5,  'TOMBO-0005', 'emprestado', 3),
    (6,  'TOMBO-0006', 'disponivel', 4),
    (7,  'TOMBO-0007', 'manutencao', 4),
    (8,  'TOMBO-0008', 'disponivel', 5),
    (9,  'TOMBO-0009', 'disponivel', 6),
    (10, 'TOMBO-0010', 'disponivel', 7),
    (11, 'TOMBO-0011', 'disponivel', 8);   -- livro novo, ainda sem empréstimos

-- 3) Movimentação -------------------------------------------------------
-- data_devolucao NULL indica empréstimo em aberto (exemplares 2, 3 e 5,
-- que por isso estão com status 'emprestado').

INSERT INTO emprestimo
    (id_emprestimo, data_emprestimo, data_prevista_devolucao, data_devolucao,
     id_aluno, id_exemplar, id_funcionario, id_regra) VALUES
    (1, '2026-09-01', '2026-09-08', '2026-09-07', 1, 1,  1, 1),
    (2, '2026-09-10', '2026-09-17', '2026-09-25', 2, 4,  2, 1),   -- 8 dias de atraso
    (3, '2026-10-05', '2026-10-08', '2026-10-08', 3, 6,  1, 2),
    (4, '2026-10-12', '2026-10-26', '2026-10-24', 5, 8,  2, 3),
    (5, '2026-10-20', '2026-10-27', '2026-11-10', 4, 9,  1, 1),   -- 14 dias de atraso
    (6, '2026-11-05', '2026-11-12', NULL,         1, 2,  2, 1),   -- em aberto e atrasado
    (7, '2026-11-10', '2026-11-24', NULL,         5, 3,  1, 3),   -- em aberto
    (8, '2026-11-12', '2026-11-19', NULL,         2, 5,  3, 1),   -- em aberto, vence hoje
    (9, '2026-11-15', '2026-11-18', '2026-11-17', 3, 10, 2, 2);

INSERT INTO reserva (id_reserva, data_reserva, status, id_aluno, id_livro) VALUES
    (1, '2026-11-14', 'ativa',     3, 2),
    (2, '2026-11-16', 'ativa',     6, 3),
    (3, '2026-10-01', 'atendida',  5, 5),
    (4, '2026-10-15', 'cancelada', 2, 7),
    (5, '2026-10-28', 'ativa',     6, 7);

-- Multa = dias de atraso x multa_por_dia da regra (1,50):
--   empréstimo 2: 8 dias  x 1,50 = 12,00 (paga)
--   empréstimo 5: 14 dias x 1,50 = 21,00 (pendente)
INSERT INTO multa (id_multa, valor, data_geracao, data_pagamento, id_emprestimo) VALUES
    (1, 12.00, '2026-09-25', '2026-09-28', 2),
    (2, 21.00, '2026-11-10', NULL,         5);

INSERT INTO ocorrencia
    (id_ocorrencia, tipo, descricao, data_ocorrencia, id_exemplar, id_funcionario, id_emprestimo) VALUES
    (1, 'dano',       'Capa danificada na devolução',                '2026-09-25', 4, 2, 2),
    (2, 'manutencao', 'Encadernação solta, enviado para reparo',     '2026-11-02', 7, 1, NULL),
    (3, 'atraso',     'Aluno notificado por e-mail sobre o atraso',  '2026-11-13', 2, 2, 6);
