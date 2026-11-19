-- =====================================================================
-- BiblioTech - Experiência Prática IV
-- Script 05: exclusão de registros (DELETE)
-- Todas as instruções usam WHERE preciso e respeitam as chaves
-- estrangeiras: só se exclui o que não é referenciado por outra tabela,
-- ou os dependentes são removidos antes do registro principal.
-- =====================================================================

-- D1) Exclui uma ocorrência lançada por engano (ocorrência 2, de
--     manutenção). A tabela ocorrencia não é referenciada por nenhuma
--     outra, então a exclusão é segura.
DELETE FROM ocorrencia
WHERE  id_ocorrencia = 2
  AND  tipo = 'manutencao';

-- D2) Exclui a reserva 4, que foi cancelada, para limpar o histórico.
--     O filtro por status impede apagar uma reserva ainda válida.
DELETE FROM reserva
WHERE  id_reserva = 4
  AND  status = 'cancelada';

-- D3) Exclui a categoria 'Matemática' (id 3), que não tem livros. A
--     subconsulta garante que a categoria só seja removida se nenhum
--     livro depender dela.
DELETE FROM categoria
WHERE  id_categoria = 3
  AND  NOT EXISTS (
         SELECT 1
         FROM   livro
         WHERE  livro.id_categoria = categoria.id_categoria
       );

-- D4) Remove o livro 8 ('Estruturas de Dados em C'), que nunca foi
--     emprestado, respeitando a ordem das dependências:
--       1º exemplares do livro (só os que nunca foram emprestados);
--       2º o livro (livro_autor é apagada junto, por ON DELETE CASCADE);
--       3º o autor 8, se ele não tiver mais nenhum livro.
BEGIN;

DELETE FROM exemplar
WHERE  id_livro = 8
  AND  NOT EXISTS (
         SELECT 1
         FROM   emprestimo
         WHERE  emprestimo.id_exemplar = exemplar.id_exemplar
       );

DELETE FROM livro
WHERE  id_livro = 8
  AND  NOT EXISTS (
         SELECT 1
         FROM   exemplar
         WHERE  exemplar.id_livro = livro.id_livro
       );

DELETE FROM autor
WHERE  id_autor = 8
  AND  NOT EXISTS (
         SELECT 1
         FROM   livro_autor
         WHERE  livro_autor.id_autor = autor.id_autor
       );

COMMIT;

-- Exclusões que o banco RECUSA (integridade referencial). Estão
-- comentadas para não interromper o script; descomente para testar:
--   DELETE FROM categoria  WHERE id_categoria  = 1;  -- tem livros
--   DELETE FROM exemplar   WHERE id_exemplar   = 1;  -- tem empréstimo
--   DELETE FROM emprestimo WHERE id_emprestimo = 5;  -- tem multa
--   DELETE FROM aluno      WHERE id_aluno      = 1;  -- tem empréstimos

-- Conferência
SELECT id_ocorrencia FROM ocorrencia ORDER BY id_ocorrencia;     -- sem a 2
SELECT id_reserva, status FROM reserva ORDER BY id_reserva;      -- sem a 4
SELECT id_categoria, nome FROM categoria ORDER BY id_categoria;  -- sem a 3
SELECT COUNT(*) AS livro_8 FROM livro WHERE id_livro = 8;        -- esperado: 0
