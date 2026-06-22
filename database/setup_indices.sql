-- 1. Índice na tabela de Livros
-- Justificativa: O título é o campo de busca mais acessado diariamente pelos alunos na View do acervo público. O índice evitará o Full Table Scan.
CREATE INDEX idx_livros_titulo ON facisas_archive.livros(titulo);

-- 2. Índice na tabela de Empréstimos
-- Justificativa: A View de livros atrasados e a procedure de multas realizam varreduras constantes buscando as datas de devolução previstas que já venceram.
CREATE INDEX idx_emprestimos_data_prevista ON facisas_archive.emprestimos(data_prevista);

-- 3. Índice na tabela de Usuários
-- Justificativa: A busca direta pelo nome de alunos ou funcionários é uma operação rotineira de identificação no balcão da biblioteca.
CREATE INDEX idx_usuarios_nome ON facisas_archive.usuarios(nome);