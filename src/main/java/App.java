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
                "Facisa's Archive - Bem vindo",
                JOptionPane.DEFAULT_OPTION, JOptionPane.QUESTION_MESSAGE,
                null, perfis, perfis[0]);

        if (escolhaPerfil == 2 || escolhaPerfil == JOptionPane.CLOSED_OPTION) {
            System.exit(0);
        }

        String usuarioBanco = JOptionPane.showInputDialog("Digite seu usuário do sistema:");
        String senhaBanco = JOptionPane.showInputDialog("Digite sua senha:");

        try {
            Connection conexao = Conexao.conectar(usuarioBanco, senhaBanco);
            JOptionPane.showMessageDialog(null, "Conexão estabelecida com sucesso!");

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
        String[] opcoesMenu = {"1. Cadastrar Livro", "2. Realizar Empréstimo", "5. Excluir Livro", "7. Sair"};

        while (true) {
            String escolha = (String) JOptionPane.showInputDialog(null,
                    "Menu Operacional - Facisa's Archive:\nEscolha uma opção:",
                    "Painel do Funcionário",
                    JOptionPane.PLAIN_MESSAGE, null, opcoesMenu, opcoesMenu[0]);

            if (escolha == null || escolha.contains("7.")) break;

            if (escolha.contains("1.")) {
                try {
                    Livro novoLivro = new Livro();
                    novoLivro.setTitulo(JOptionPane.showInputDialog("Título do Livro:"));
                    novoLivro.setAutor(JOptionPane.showInputDialog("Autor:"));
                    novoLivro.setIsbn(JOptionPane.showInputDialog("ISBN:"));
                    novoLivro.setPrecoCusto(Double.parseDouble(JOptionPane.showInputDialog("Preço de Custo (ex: 150.00):")));
                    novoLivro.setQuantidadeEstoque(Integer.parseInt(JOptionPane.showInputDialog("Quantidade em Estoque:")));
                    novoLivro.setStatus("DISPONIVEL");

                    livroDAO.cadastrarLivro(novoLivro);
                } catch (Exception e) {
                    JOptionPane.showMessageDialog(null, "Dados inválidos digitados. Operação cancelada.", "Erro", JOptionPane.ERROR_MESSAGE);
                }
            }
            else if (escolha.contains("2.")) {
                try {
                    String idUsuarioStr = JOptionPane.showInputDialog("Digite o ID do Usuário (Quem vai pegar o livro):");
                    String idLivroStr = JOptionPane.showInputDialog("Digite o ID do Livro (O que será emprestado):");

                    if (idUsuarioStr != null && idLivroStr != null && !idUsuarioStr.isEmpty() && !idLivroStr.isEmpty()) {
                        livroDAO.realizarEmprestimo(Integer.parseInt(idUsuarioStr), Integer.parseInt(idLivroStr));
                    }
                } catch (Exception e) {
                    JOptionPane.showMessageDialog(null, "IDs inválidos. Apenas números inteiros são aceitos.", "Erro", JOptionPane.ERROR_MESSAGE);
                }
            }
            else if (escolha.contains("5.")) {
                String idStr = JOptionPane.showInputDialog("Digite o ID do livro que deseja EXCLUIR:");
                if (idStr != null && !idStr.isEmpty()) {
                    livroDAO.excluirLivro(Integer.parseInt(idStr));
                }
            }
        }
    }


    private static void menuAluno(Connection conexao) {
        LivroDAO livroDAO = new LivroDAO(conexao);
        String[] opcoesMenu = {"1. Consultar Acervo Disponível", "7. Sair"};

        while (true) {
            String escolha = (String) JOptionPane.showInputDialog(null,
                    "Menu do Aluno - Facisa's Archive:\nEscolha uma opção:",
                    "Painel do Aluno",
                    JOptionPane.PLAIN_MESSAGE, null, opcoesMenu, opcoesMenu[0]);

            if (escolha == null || escolha.contains("7.")) break;

            if (escolha.contains("1.")) {
                livroDAO.consultarAcervoPublico();
            }
        }
    }
}