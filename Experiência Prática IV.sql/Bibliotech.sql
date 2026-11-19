# BiblioTech - Experiência Prática IV (SQL DML)

Scripts SQL do mini-mundo **BiblioTech** (biblioteca universitária), disciplina de Modelagem de Banco de Dados. Eles implementam, em um banco relacional, o modelo lógico já normalizado até a 3FN, e demonstram os comandos `INSERT`, `SELECT`, `UPDATE` e `DELETE` respeitando a integridade referencial.

## Arquivos

| Arquivo | Conteúdo |
|---|---|
| `01_criacao_tabelas.sql` | Criação das 12 tabelas, com chaves primárias e estrangeiras, `UNIQUE`, `NOT NULL`, `CHECK` e `DEFAULT` |
| `02_insercoes.sql` | Povoamento de todas as tabelas com dados fictícios e coerentes entre si |
| `03_consultas.sql` | 11 consultas (`SELECT`) com `JOIN`, `WHERE`, `ORDER BY`, `LIMIT`, agregações, `LEFT JOIN` e subconsulta |
| `04_atualizacoes_e_exclusoes.sql` | `UPDATE` e `DELETE` condicionais, em transações, com demonstração de integridade referencial |
| `05_validacao_de_erros.sql` | 9 instruções inválidas (comentadas) que mostram os erros de integridade e de tipo e como corrigi-los |

## Modelo

Tabelas: `categoria`, `autor`, `livro`, `livro_autor`, `exemplar`, `aluno`, `funcionario`, `regra_emprestimo`, `emprestimo`, `reserva`, `multa` e `ocorrencia`.

Principais relacionamentos e cardinalidades:

- `categoria` 1:N `livro`
- `livro` N:M `autor`, resolvido pela tabela associativa `livro_autor`
- `livro` 1:N `exemplar`
- `aluno`, `exemplar`, `funcionario` e `regra_emprestimo` 1:N `emprestimo`
- `aluno` 1:N `reserva` e `livro` 1:N `reserva`
- `emprestimo` 1:0..1 `multa` (garantido por `UNIQUE` em `multa.id_emprestimo`)
- `exemplar` e `funcionario` 1:N `ocorrencia`; `emprestimo` 0..1:N `ocorrencia`

## Como executar

Os scripts usam SQL padrão e rodam em **MySQL (Workbench)** e **PostgreSQL (pgAdmin)**.

1. Crie o banco e conecte-se a ele:
   - MySQL: `CREATE DATABASE bibliotech; USE bibliotech;`
   - PostgreSQL: `CREATE DATABASE bibliotech;` e abra uma conexão com ele.
2. Execute os scripts **nesta ordem**: `01`, `02`, `03` e `04`. O `05` é opcional e pode ser executado após o `02`.
   - No Workbench: abra o arquivo e clique no ícone do raio (executar tudo).
   - No pgAdmin: abra a Query Tool, carregue o arquivo e execute (F5).
3. O script 01 pode ser reexecutado a qualquer momento: ele recria as tabelas do zero (`DROP TABLE IF EXISTS`). Depois de reexecutá-lo, rode também o 02 para repovoar.

Observações:

- No MySQL Workbench, o modo *safe updates* pode bloquear `UPDATE`/`DELETE` cujo `WHERE` não use a chave primária (erro 1175). Se isso acontecer, execute `SET SQL_SAFE_UPDATES = 0;` antes do script 04.
- Os identificadores são informados manualmente nos `INSERT`, para que os scripts sejam idênticos nos dois SGBDs.
- A data de referência do cenário é **19/11/2026**. Nas consultas de atraso, ela aparece como literal; para usar a data real do servidor, troque por `CURRENT_DATE`.
- Os dados (nomes, e-mails, telefones e ISBNs) são fictícios.

## Regras de integridade aplicadas

- **Integridade referencial:** toda chave estrangeira é declarada. Por padrão, o banco recusa excluir ou alterar um registro que ainda é referenciado. A única exceção é `livro_autor`, que usa `ON DELETE CASCADE` em `id_livro`, pois é apenas uma tabela de ligação.
- **Valores válidos:** `CHECK` limita `status` de exemplar e reserva, `situacao` de aluno, prazos e valores não negativos, e exige `data_prevista_devolucao >= data_emprestimo`.
- **Unicidade:** matrícula, e-mail, ISBN e código de patrimônio não se repetem.
- **Consistência do cenário:** exemplares com status `emprestado` são exatamente os que têm empréstimo em aberto (`data_devolucao IS NULL`), e o valor das multas segue `dias de atraso x multa_por_dia` da regra do empréstimo.

## Consultas (script 03)

| Consulta | O que responde |
|---|---|
| C1 | Livros com a categoria |
| C2 | Livros com seus autores (N:M) |
| C3 | Exemplares disponíveis por livro |
| C4 | Empréstimos em aberto, com aluno, livro e atendente |
| C5 | Empréstimos em atraso na data de referência |
| C6 | Total de empréstimos por aluno (inclui quem nunca emprestou) |
| C7 | Multas pendentes |
| C8 | Livros mais emprestados |
| C9 | Livros nunca emprestados (`NOT EXISTS`) |
| C10 | Reservas ativas |
| C11 | Os 3 livros mais emprestados (`LIMIT`) |

## Alterações e exclusões (script 04)

| Operação | Descrição |
|---|---|
| U1 | Devolução em atraso do empréstimo 6: registra a devolução, libera o exemplar e gera a multa (transação) |
| U2 | Pagamento da multa 2 e reativação do aluno 4, somente se não houver outra multa pendente (transação) |
| U3 | Renovação do empréstimo 8 por mais 7 dias, apenas se estiver em aberto |
| U4 | Expiração de reservas ativas anteriores a 04/11/2026 |
| D1 | Exclusão de uma ocorrência lançada por engano |
| D2 | Exclusão das reservas canceladas |
| D3 | Exclusão da categoria sem livros ("Matemática") |
| D4 | Demonstração: a exclusão de `categoria` 1 falha por ter livros; um empréstimo com ocorrência só é excluído depois do registro dependente |

As instruções que violam a integridade referencial estão **comentadas** no script 04 para não interromper a execução. Descomente-as para ver o erro retornado pelo SGBD.

## Verificação

Os quatro scripts foram executados em sequência em um banco de teste com chaves estrangeiras ativas, sem erros e sem violações de integridade (`foreign_key_check` vazio antes e depois do script 04). Também foi confirmado que as instruções que deveriam falhar (excluir categoria com livros, segunda multa para o mesmo empréstimo, status inválido de exemplar, aluno inexistente em empréstimo e as demais do script 05) são de fato recusadas. A única exceção no ambiente de teste foi o erro de tipo de data (E8), que o SQLite não valida; no MySQL (modo estrito) e no PostgreSQL ele é recusado.
