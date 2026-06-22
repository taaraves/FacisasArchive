package dao;

import model.Livro;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.CallableStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import javax.swing.JOptionPane;

public class LivroDAO {
    private Connection conexaoAtiva;

    public LivroDAO(Connection conexao) {
        this.conexaoAtiva = conexao;
    }

    public void cadastrarLivro(Livro livro) {
        String sql = "INSERT INTO livros (titulo, autor, isbn, preco_custo, quantidade_estoque, status) VALUES (?, ?, ?, ?, ?, ?)";
        try (PreparedStatement stmt = conexaoAtiva.prepareStatement(sql)) {
            stmt.setString(1, livro.getTitulo());
            stmt.setString(2, livro.getAutor());
            stmt.setString(3, livro.getIsbn());
            stmt.setDouble(4, livro.getPrecoCusto());
            stmt.setInt(5, livro.getQuantidadeEstoque());
            stmt.setString(6, livro.getStatus());

            stmt.executeUpdate();
            JOptionPane.showMessageDialog(null, "Livro '" + livro.getTitulo() + "' cadastrado com sucesso!");
        } catch (SQLException e) {
            JOptionPane.showMessageDialog(null, "Erro ao cadastrar livro:\n" + e.getMessage(), "Erro SGBD", JOptionPane.ERROR_MESSAGE);
        }
    }

    public void realizarEmprestimo(int idUsuario, int idLivro) {
        String sql = "{CALL sp_transacao_emprestimo(?, ?)}";
        try (CallableStatement stmt = conexaoAtiva.prepareCall(sql)) {
            stmt.setInt(1, idUsuario);
            stmt.setInt(2, idLivro);
            stmt.execute();
            JOptionPane.showMessageDialog(null, "Empréstimo realizado com sucesso! O estoque foi atualizado.", "Transação Concluída", JOptionPane.INFORMATION_MESSAGE);
        } catch (SQLException e) {
            JOptionPane.showMessageDialog(null, "Transação negada pelo Banco de Dados:\n" + e.getMessage(), "Bloqueio de Regra de Negócio", JOptionPane.WARNING_MESSAGE);
        }
    }

    public void renovarEmprestimo(int idEmprestimo) {
        String sql = "{CALL sp_renovar_emprestimo(?)}";
        try (CallableStatement stmt = conexaoAtiva.prepareCall(sql)) {
            stmt.setInt(1, idEmprestimo);
            stmt.execute();
            JOptionPane.showMessageDialog(null, "Empréstimo renovado por mais 7 dias!", "Renovação Concluída", JOptionPane.INFORMATION_MESSAGE);
        } catch (SQLException e) {
            JOptionPane.showMessageDialog(null, "Transação negada pelo Banco de Dados:\n" + e.getMessage(), "Bloqueio de Regra de Negócio", JOptionPane.WARNING_MESSAGE);
        }
    }

    public void realizarDevolucao(int idEmprestimo) {
        try {

            String sqlMulta = "{CALL sp_calcular_multa(?, ?)}";
            try (CallableStatement stmtMulta = conexaoAtiva.prepareCall(sqlMulta)) {
                stmtMulta.setInt(1, idEmprestimo);
                stmtMulta.registerOutParameter(2, java.sql.Types.DECIMAL);
                stmtMulta.execute();

                double valorMulta = stmtMulta.getDouble(2);

                if (valorMulta > 0) {
                    JOptionPane.showMessageDialog(null, "Atraso detectado!\nGerando multa no valor de: R$ " + valorMulta, "Aviso Financeiro", JOptionPane.WARNING_MESSAGE);
                    String sqlInsertMulta = "INSERT INTO multas (id_emprestimo_fk, valor, pago) VALUES (?, ?, 1)";
                    try (PreparedStatement psMulta = conexaoAtiva.prepareStatement(sqlInsertMulta)) {
                        psMulta.setInt(1, idEmprestimo);
                        psMulta.setDouble(2, valorMulta);
                        psMulta.executeUpdate();
                    }
                }
            }


            String updateEmp = "UPDATE emprestimos SET data_devolucao = CURRENT_TIMESTAMP WHERE id_emprestimo = ?";
            int idLivro = -1;
            try (PreparedStatement ps = conexaoAtiva.prepareStatement(updateEmp)) {
                ps.setInt(1, idEmprestimo);
                ps.executeUpdate();
            }

            String getLivro = "SELECT id_livro_fk FROM emprestimos WHERE id_emprestimo = ?";
            try (PreparedStatement psL = conexaoAtiva.prepareStatement(getLivro)) {
                psL.setInt(1, idEmprestimo);
                try (ResultSet rs = psL.executeQuery()) {
                    if (rs.next()) idLivro = rs.getInt("id_livro_fk");
                }
            }


            if (idLivro != -1) {
                String updateEstoque = "UPDATE livros SET quantidade_estoque = quantidade_estoque + 1 WHERE id_livro = ?";
                try (PreparedStatement psE = conexaoAtiva.prepareStatement(updateEstoque)) {
                    psE.setInt(1, idLivro);
                    psE.executeUpdate();
                }
            }
            JOptionPane.showMessageDialog(null, "Devolução concluída! Livro retornado ao acervo.");

        } catch (SQLException e) {
            JOptionPane.showMessageDialog(null, "Erro na devolução:\n" + e.getMessage(), "Erro", JOptionPane.ERROR_MESSAGE);
        }
    }

    public void consultarAcervoPublico() {
        String sql = "SELECT * FROM vw_acervo_publico";
        StringBuilder acervo = new StringBuilder("--- Acervo Disponível ---\n\n");

        try (PreparedStatement stmt = conexaoAtiva.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            boolean temLivro = false;
            while (rs.next()) {
                temLivro = true;
                acervo.append("ID: ").append(rs.getInt("id_livro"))
                        .append(" | Título: ").append(rs.getString("titulo"))
                        .append(" | Autor: ").append(rs.getString("autor"))
                        .append(" | Estoque: ").append(rs.getInt("quantidade_estoque"))
                        .append(" | Status: ").append(rs.getString("status")).append("\n");
            }
            if (!temLivro) acervo.append("Nenhum livro disponível no momento.");
            JOptionPane.showMessageDialog(null, acervo.toString(), "Visão do Aluno", JOptionPane.INFORMATION_MESSAGE);
        } catch (SQLException e) {
            JOptionPane.showMessageDialog(null, "Erro ao carregar acervo:\n" + e.getMessage(), "Acesso Negado", JOptionPane.ERROR_MESSAGE);
        }
    }

    public void listarMeusEmprestimos(int idUsuario) {
        String sql = "SELECT l.titulo, e.data_saida, e.data_prevista, e.data_devolucao FROM emprestimos e JOIN livros l ON e.id_livro_fk = l.id_livro WHERE e.id_usuario_fk = ?";
        StringBuilder relatorio = new StringBuilder("--- Histórico de Empréstimos ---\n\n");
        try (PreparedStatement stmt = conexaoAtiva.prepareStatement(sql)) {
            stmt.setInt(1, idUsuario);
            try (ResultSet rs = stmt.executeQuery()) {
                boolean temReg = false;
                while (rs.next()) {
                    temReg = true;
                    String devolvido = rs.getString("data_devolucao") == null ? "Pendente" : rs.getString("data_devolucao");
                    relatorio.append("Livro: ").append(rs.getString("titulo"))
                            .append("\n  - Retirada: ").append(rs.getString("data_saida"))
                            .append("\n  - Prazo: ").append(rs.getString("data_prevista"))
                            .append("\n  - Devolução: ").append(devolvido).append("\n\n");
                }
                if (!temReg) relatorio.append("Você não tem empréstimos registrados.");
                JOptionPane.showMessageDialog(null, relatorio.toString(), "Meus Empréstimos", JOptionPane.INFORMATION_MESSAGE);
            }
        } catch (SQLException e) {
            JOptionPane.showMessageDialog(null, "Erro ao buscar histórico:\n" + e.getMessage(), "Erro", JOptionPane.ERROR_MESSAGE);
        }
    }

    public void exibirDashboardFinanceiro() {
        String sql = "SELECT * FROM vw_dashboard_financeiro";
        try (PreparedStatement stmt = conexaoAtiva.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                JOptionPane.showMessageDialog(null, "Total Arrecadado em Multas Pagas: R$ " + rs.getDouble("total_arrecadado"), "Gerência Financeira", JOptionPane.INFORMATION_MESSAGE);
            }
        } catch (SQLException e) {
            JOptionPane.showMessageDialog(null, "Acesso Negado! Apenas o Gerente pode ver finanças.\n(" + e.getMessage() + ")", "Segurança SGBD", JOptionPane.ERROR_MESSAGE);
        }
    }

    public void excluirLivro(int idLivro) {
        String sql = "DELETE FROM livros WHERE id_livro = ?";
        try (PreparedStatement stmt = conexaoAtiva.prepareStatement(sql)) {
            stmt.setInt(1, idLivro);
            int linhasAfetadas = stmt.executeUpdate();
            if (linhasAfetadas > 0) {
                JOptionPane.showMessageDialog(null, "Livro excluído com sucesso do acervo!");
            } else {
                JOptionPane.showMessageDialog(null, "ID não encontrado.");
            }
        } catch (SQLException e) {
            JOptionPane.showMessageDialog(null, "ERRO: Acesso Negado! Seu perfil de usuário não tem permissão para excluir registros do sistema.\n(" + e.getMessage() + ")", "Bloqueio de Segurança SGBD", JOptionPane.ERROR_MESSAGE);
        }
    }
}