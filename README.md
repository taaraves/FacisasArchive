# FacisasArchive


Sistema de Gestão Bibliotecária desenvolvido como projeto prático para a disciplina de **Banco de Dados Orientado a Objetos (BDOO)**. O objetivo central deste projeto é aplicar conceitos de **POO (Java)** integrados a um banco de dados **MySQL** que atua como a camada principal de segurança, integridade e regras de negócio.

## Sobre o Projeto
O FacisasArchive impõe regras via **Stored Procedures, Triggers, Views e Controle de Acesso (GRANTs)**, garantindo que a segurança do sistema seja preservada mesmo que a interface gráfica seja contornada.

### Principais Tecnologias
- **Java 21** com **JDBC** para persistência.
- **MySQL 8.0** para lógica de SGBD.
- **Maven** para gerenciamento de dependências.
- **Swing** para interface gráfica (JOptionPanes).

---

## Instalação e Configuração

### 1. Requisitos
- [JDK 21](https://adoptium.net/) instalado.
- [MySQL Workbench](https://www.mysql.com/products/workbench/) ou similar.
- [IntelliJ IDEA](https://www.jetbrains.com/idea/) (Recomendado).

### 2. Configuração do Banco de Dados
Para rodar o projeto, siga a ordem estrita de importação na pasta `/database`:

1. **Estrutura:** Importe `facisa_archive.sql` via *Data Import/Restore* no MySQL Workbench (certifique-se de marcar a opção *Dump Structure and Data*).
2. **Segurança:** Abra o script `setup_usuarios.sql` em uma aba de Query e execute-o para criar os perfis (`usr_gerente`, `usr_bibliotecario`, etc.) e atribuir os privilégios.
3. **Otimização:** Execute o script `setup_indices.sql` para garantir a performance das consultas (Conforme item 6.1 do roteiro).

### 3. Configuração do Projeto Java
1. Clone este repositório.
2. Abra no IntelliJ e aguarde o Maven baixar as dependências (`mysql-connector-java`).
3. Compile e execute a classe `App.java`.

---

## Plano de Testes (Passo a Passo)

Para validar todos os requisitos do roteiro, execute os seguintes testes:

### Teste A: Isolamento e View Pública (Perfil Aluno)
1. Execute `App.java` e selecione **Aluno**.
2. Usuário: `usr_aluno` | Senha: `senha_aluno`.
3. Selecione "Consultar Acervo". O sistema deve exibir os dados, mas ocultar o preço de custo (prova de encapsulamento da View).

### Teste B: Bloqueio de Segurança (Teste do Estagiário)
1. Execute `App.java` e selecione **Funcionário**.
2. Usuário: `usr_estagiario` | Senha: `senha_estagiario`.
3. Tente a opção "Excluir Livro". O sistema deve disparar um erro de *Acesso Negado* vindo do MySQL, provando que o banco bloqueou o `DELETE`.

### Teste C: Lógica de Multas e Devolução
1. Com o perfil de **Funcionário** (`usr_bibliotecario` / `senha_biblio`), selecione "Realizar Devolução".
2. Informe o ID de um empréstimo em atraso. O sistema deve calcular automaticamente a multa via `sp_calcular_multa` e registrar na tabela de multas.

### Teste D: Auditoria (Trigger)
1. Com perfil de **Gerente** (`usr_gerente` / `senha_gerente`), exclua um livro.
2. No MySQL, execute `SELECT * FROM log_auditoria;`. O sistema deve ter registrado a ação do usuário, o horário e os dados antigos automaticamente.

---

##  Notas Acadêmicas
- **Encapsulamento/POO:** Validado na modelagem de `Usuario` (abstrata) e classes filhas.
- **Segurança:** Regras de acesso impostas pelo SGBD.
- **Performance:** Índices aplicados em campos de alta frequência de busca (títulos e datas).

*Projeto desenvolvido por Diego Santos Tavares e Lucas Caitano.*
