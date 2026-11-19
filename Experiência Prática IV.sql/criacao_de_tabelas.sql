-- =====================================================================
-- BiblioTech - Experiência Prática IV
-- Script 01: criação das tabelas (modelo lógico em 3FN)
-- Compatível com MySQL (Workbench) e PostgreSQL (pgAdmin).
-- Antes de executar, crie e selecione o banco:
--   MySQL:      CREATE DATABASE bibliotech; USE bibliotech;
--   PostgreSQL: CREATE DATABASE bibliotech;  (e conecte-se a ele)
-- =====================================================================

-- Remoção na ordem inversa das dependências, para permitir reexecução.
DROP TABLE IF EXISTS ocorrencia;
DROP TABLE IF EXISTS multa;
DROP TABLE IF EXISTS reserva;
DROP TABLE IF EXISTS emprestimo;
DROP TABLE IF EXISTS regra_emprestimo;
DROP TABLE IF EXISTS funcionario;
DROP TABLE IF EXISTS aluno;
DROP TABLE IF EXISTS exemplar;
DROP TABLE IF EXISTS livro_autor;
DROP TABLE IF EXISTS livro;
DROP TABLE IF EXISTS autor;
DROP TABLE IF EXISTS categoria;

CREATE TABLE categoria (
    id_categoria  INT          PRIMARY KEY,
    nome          VARCHAR(80)  NOT NULL UNIQUE
);

CREATE TABLE autor (
    id_autor       INT           PRIMARY KEY,
    nome           VARCHAR(120)  NOT NULL,
    nacionalidade  VARCHAR(60)
);

CREATE TABLE livro (
    id_livro        INT           PRIMARY KEY,
    titulo          VARCHAR(200)  NOT NULL,
    isbn            CHAR(13)      NOT NULL UNIQUE,
    ano_publicacao  INT,
    id_categoria    INT           NOT NULL,
    FOREIGN KEY (id_categoria) REFERENCES categoria (id_categoria)
);

-- Entidade associativa do relacionamento N:M entre livro e autor.
CREATE TABLE livro_autor (
    id_livro  INT NOT NULL,
    id_autor  INT NOT NULL,
    PRIMARY KEY (id_livro, id_autor),
    FOREIGN KEY (id_livro) REFERENCES livro (id_livro) ON DELETE CASCADE,
    FOREIGN KEY (id_autor) REFERENCES autor (id_autor)
);

CREATE TABLE exemplar (
    id_exemplar        INT          PRIMARY KEY,
    codigo_patrimonio  VARCHAR(20)  NOT NULL UNIQUE,
    status             VARCHAR(20)  NOT NULL DEFAULT 'disponivel',
    id_livro           INT          NOT NULL,
    CHECK (status IN ('disponivel', 'emprestado', 'manutencao', 'perdido')),
    FOREIGN KEY (id_livro) REFERENCES livro (id_livro)
);

CREATE TABLE aluno (
    id_aluno   INT           PRIMARY KEY,
    matricula  VARCHAR(20)   NOT NULL UNIQUE,
    nome       VARCHAR(120)  NOT NULL,
    email      VARCHAR(120)  UNIQUE,
    telefone   VARCHAR(20),
    situacao   VARCHAR(20)   NOT NULL DEFAULT 'ativo',
    CHECK (situacao IN ('ativo', 'suspenso', 'inativo'))
);

CREATE TABLE funcionario (
    id_funcionario  INT           PRIMARY KEY,
    nome            VARCHAR(120)  NOT NULL,
    cargo           VARCHAR(60)   NOT NULL,
    email           VARCHAR(120)  UNIQUE
);

CREATE TABLE regra_emprestimo (
    id_regra           INT            PRIMARY KEY,
    descricao          VARCHAR(80)    NOT NULL,
    prazo_dias         INT            NOT NULL,
    limite_renovacoes  INT            NOT NULL DEFAULT 0,
    multa_por_dia      DECIMAL(6,2)   NOT NULL DEFAULT 0,
    CHECK (prazo_dias > 0),
    CHECK (limite_renovacoes >= 0),
    CHECK (multa_por_dia >= 0)
);

CREATE TABLE emprestimo (
    id_emprestimo            INT   PRIMARY KEY,
    data_emprestimo          DATE  NOT NULL,
    data_prevista_devolucao  DATE  NOT NULL,
    data_devolucao           DATE,                 -- NULL = empréstimo em aberto
    id_aluno                 INT   NOT NULL,
    id_exemplar              INT   NOT NULL,
    id_funcionario           INT   NOT NULL,
    id_regra                 INT   NOT NULL,
    CHECK (data_prevista_devolucao >= data_emprestimo),
    FOREIGN KEY (id_aluno)       REFERENCES aluno (id_aluno),
    FOREIGN KEY (id_exemplar)    REFERENCES exemplar (id_exemplar),
    FOREIGN KEY (id_funcionario) REFERENCES funcionario (id_funcionario),
    FOREIGN KEY (id_regra)       REFERENCES regra_emprestimo (id_regra)
);

CREATE TABLE reserva (
    id_reserva    INT          PRIMARY KEY,
    data_reserva  DATE         NOT NULL,
    status        VARCHAR(20)  NOT NULL DEFAULT 'ativa',
    id_aluno      INT          NOT NULL,
    id_livro      INT          NOT NULL,
    CHECK (status IN ('ativa', 'atendida', 'cancelada', 'expirada')),
    FOREIGN KEY (id_aluno) REFERENCES aluno (id_aluno),
    FOREIGN KEY (id_livro) REFERENCES livro (id_livro)
);

-- UNIQUE em id_emprestimo garante a cardinalidade 1:0..1 do DER
-- (um empréstimo gera no máximo uma multa).
CREATE TABLE multa (
    id_multa        INT           PRIMARY KEY,
    valor           DECIMAL(8,2)  NOT NULL,
    data_geracao    DATE          NOT NULL,
    data_pagamento  DATE,                          -- NULL = multa pendente
    id_emprestimo   INT           NOT NULL UNIQUE,
    CHECK (valor >= 0),
    FOREIGN KEY (id_emprestimo) REFERENCES emprestimo (id_emprestimo)
);

CREATE TABLE ocorrencia (
    id_ocorrencia    INT           PRIMARY KEY,
    tipo             VARCHAR(30)   NOT NULL,
    descricao        VARCHAR(255),
    data_ocorrencia  DATE          NOT NULL,
    id_exemplar      INT           NOT NULL,
    id_funcionario   INT           NOT NULL,
    id_emprestimo    INT,                          -- opcional (0..1)
    FOREIGN KEY (id_exemplar)    REFERENCES exemplar (id_exemplar),
    FOREIGN KEY (id_funcionario) REFERENCES funcionario (id_funcionario),
    FOREIGN KEY (id_emprestimo)  REFERENCES emprestimo (id_emprestimo)
);
