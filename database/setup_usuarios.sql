-- Criação de Usuários
CREATE USER 'usr_gerente'@'localhost' IDENTIFIED BY 'senha_gerente';
CREATE USER 'usr_bibliotecario'@'localhost' IDENTIFIED BY 'senha_biblio';
CREATE USER 'usr_estagiario'@'localhost' IDENTIFIED BY 'senha_estagiario';
CREATE USER 'usr_aluno'@'localhost' IDENTIFIED BY 'senha_aluno';

-- O Administrador (Acesso Total)
GRANT ALL PRIVILEGES ON facisas_archive.* TO 'usr_gerente'@'localhost';

-- O Operador (Rotina Diária)
GRANT SELECT, INSERT, UPDATE ON facisas_archive.livros TO 'usr_bibliotecario'@'localhost';
GRANT SELECT, INSERT, UPDATE ON facisas_archive.emprestimos TO 'usr_bibliotecario'@'localhost';
GRANT SELECT, INSERT, UPDATE ON facisas_archive.multas TO 'usr_bibliotecario'@'localhost';
GRANT SELECT, INSERT ON facisas_archive.usuarios TO 'usr_bibliotecario'@'localhost';
GRANT SELECT, INSERT ON facisas_archive.enderecos TO 'usr_bibliotecario'@'localhost';

-- O Estagiário (Privilégio Mínimo - Bloqueado de fazer DELETE)
GRANT SELECT ON facisas_archive.livros TO 'usr_estagiario'@'localhost';
GRANT SELECT, INSERT ON facisas_archive.emprestimos TO 'usr_estagiario'@'localhost';
REVOKE DELETE ON facisas_archive.livros FROM 'usr_estagiario'@'localhost';

-- O Aluno (Somente Leitura nas Views Públicas)
GRANT SELECT ON facisas_archive.vw_acervo_publico TO 'usr_aluno'@'localhost';
GRANT SELECT ON facisas_archive.vw_ranking_leitura TO 'usr_aluno'@'localhost';

FLUSH PRIVILEGES;