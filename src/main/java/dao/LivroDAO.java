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
                        .append(" | Status: ").append(rs.getString("status"))
                        .append("\n");
            }
            if (!temLivro) acervo.append("Nenhum livro disponível no momento.");

            JOptionPane.showMessageDialog(null, acervo.toString(), "Visão do Aluno", JOptionPane.INFORMATION_MESSAGE);
        } catch (SQLException e) {
            JOptionPane.showMessageDialog(null, "Erro ao carregar acervo:\n" + e.getMessage(), "Acesso Negado", JOptionPane.ERROR_MESSAGE);
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
            JOptionPane.showMessageDialog(null,
                    "ERRO: Acesso Negado! Seu perfil de usuário não tem permissão para excluir registros do sistema.\n(Detalhe técnico: " + e.getMessage() + ")",
                    "Bloqueio de Segurança SGBD",
                    JOptionPane.ERROR_MESSAGE);
        }
    }
}