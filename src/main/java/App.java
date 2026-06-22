import dao.Conexao;
import dao.LivroDAO;
import model.Livro;

import javax.swing.JOptionPane;
import java.sql.Connection;
import java.sql.SQLException;

public class App {
    public static void main(String[] args) {
        String[] perfis = {"Funcionário", "Aluno", "Sair"};
        int escolhaPerfil = JOptionPane.showOptionDialog(null,
                "Qual é o seu perfil de acesso?",
                "LibriTech - Bem vindo",
                JOptionPane.DEFAULT_OPTION, JOptionPane.QUESTION_MESSAGE,
                null, perfis, perfis[0]);

        if (escolhaPerfil == 2 || escolhaPerfil == JOptionPane.CLOSED_OPTION) {
            System.exit(0);
        }

        String usuarioBanco = JOptionPane.showInputDialog("Digite seu usuário do sistema (Ex: usr_gerente, usr_aluno):");
        String senhaBanco = JOptionPane.showInputDialog("Digite sua senha:");

        try {
            Connection conexao = Conexao.conectar(usuarioBanco, senhaBanco);
            JOptionPane.showMessageDialog(null, "Conexão SGBD estabelecida com sucesso!");

            if (escolhaPerfil == 0) {
                menuFuncionario(conexao);
            } else if (escolhaPerfil == 1) {
                menuAluno(conexao);
            }

        } catch (SQLException e) {
            JOptionPane.showMessageDialog(null, "Falha no login! Usuário ou senha incorretos.\n" + e.getMessage(), "Erro", JOptionPane.ERROR_MESSAGE);
        }
    }

    private static void menuFuncionario(Connection conexao) {
        LivroDAO livroDAO = new LivroDAO(conexao);
        String[] opcoesMenu = {
                "1. Cadastrar Livro",
                "2. Realizar Empréstimo",
                "3. Renovar Empréstimo",
                "4. Realizar Devolução",
                "5. Excluir Livro",
                "6. Relatório Financeiro",
                "7. Sair"
        };

        while (true) {
            String escolha = (String) JOptionPane.showInputDialog(null,
                    "Menu Operacional - Funcionários:\nEscolha uma opção:",
                    "Painel do Funcionário",
                    JOptionPane.PLAIN_MESSAGE, null, opcoesMenu, opcoesMenu[0]);

            if (escolha == null || escolha.contains("7.")) break;

            try {
                if (escolha.contains("1.")) {
                    Livro novoLivro = new Livro();
                    novoLivro.setTitulo(JOptionPane.showInputDialog("Título do Livro:"));
                    novoLivro.setAutor(JOptionPane.showInputDialog("Autor:"));
                    novoLivro.setIsbn(JOptionPane.showInputDialog("ISBN:"));
                    novoLivro.setPrecoCusto(Double.parseDouble(JOptionPane.showInputDialog("Preço de Custo (ex: 150.00):")));
                    novoLivro.setQuantidadeEstoque(Integer.parseInt(JOptionPane.showInputDialog("Quantidade em Estoque:")));
                    novoLivro.setStatus("DISPONIVEL");
                    livroDAO.cadastrarLivro(novoLivro);
                }
                else if (escolha.contains("2.")) {
                    String idUsu = JOptionPane.showInputDialog("ID do Usuário (Quem pega o livro):");
                    String idLiv = JOptionPane.showInputDialog("ID do Livro:");
                    if (idUsu != null && idLiv != null) livroDAO.realizarEmprestimo(Integer.parseInt(idUsu), Integer.parseInt(idLiv));
                }
                else if (escolha.contains("3.")) {
                    String idEmp = JOptionPane.showInputDialog("ID do Empréstimo para RENOVAÇÃO:");
                    if (idEmp != null) livroDAO.renovarEmprestimo(Integer.parseInt(idEmp));
                }
                else if (escolha.contains("4.")) {
                    String idEmp = JOptionPane.showInputDialog("ID do Empréstimo para DEVOLUÇÃO:");
                    if (idEmp != null) livroDAO.realizarDevolucao(Integer.parseInt(idEmp));
                }
                else if (escolha.contains("5.")) {
                    String idStr = JOptionPane.showInputDialog("ID do livro que deseja EXCLUIR:");
                    if (idStr != null) livroDAO.excluirLivro(Integer.parseInt(idStr));
                }
                else if (escolha.contains("6.")) {
                    livroDAO.exibirDashboardFinanceiro();
                }
            } catch (Exception e) {
                JOptionPane.showMessageDialog(null, "Entrada de dados inválida.", "Erro", JOptionPane.ERROR_MESSAGE);
            }
        }
    }

    private static void menuAluno(Connection conexao) {
        LivroDAO livroDAO = new LivroDAO(conexao);
        String[] opcoesMenu = {"1. Consultar Acervo Público", "2. Meus Empréstimos", "3. Sair"};

        while (true) {
            String escolha = (String) JOptionPane.showInputDialog(null,
                    "Portal do Aluno:\nEscolha uma opção:",
                    "Painel do Aluno",
                    JOptionPane.PLAIN_MESSAGE, null, opcoesMenu, opcoesMenu[0]);

            if (escolha == null || escolha.contains("3.")) break;

            if (escolha.contains("1.")) {
                livroDAO.consultarAcervoPublico();
            } else if (escolha.contains("2.")) {
                String myId = JOptionPane.showInputDialog("Confirme o seu ID de Aluno para ver o histórico:");
                if (myId != null && !myId.isEmpty()) {
                    livroDAO.listarMeusEmprestimos(Integer.parseInt(myId));
                }
            }
        }
    }
}