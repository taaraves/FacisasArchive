package dao;

import model.Livro;
import javax.swing.*;
import java.sql.*;

public class LivroDAO {
    private Connection conexao;

    public LivroDAO(Connection conexao) {
        this.conexao = conexao;
    }

    public void cadastrarLivro(Livro livro) {
        String sql = "INSERT INTO livros (titulo, autor, isbn, preco_custo, quantidade_estoque, status) VALUES (?, ?, ?, ?, ?, ?)";
        try (PreparedStatement ps = conexao.prepareStatement(sql)) {
            ps.setString(1, livro.getTitulo());
            ps.setString(2, livro.getAutor());
            ps.setString(3, livro.getIsbn());
            ps.setDouble(4, livro.getPrecoCusto());
            ps.setInt(5, livro.getQuantidadeEstoque());
            ps.setString(6, livro.getStatus());
            ps.executeUpdate();
            JOptionPane.showMessageDialog(null, "Livro cadastrado com sucesso!");
        } catch (SQLException e) {
            JOptionPane.showMessageDialog(null, "Erro: " + e.getMessage());
        }
    }

    public void excluirLivro(int idLivro) {
        String sql = "DELETE FROM livros WHERE id_livro = ?";
        try (PreparedStatement ps = conexao.prepareStatement(sql)) {
            ps.setInt(1, idLivro);
            ps.executeUpdate();
            JOptionPane.showMessageDialog(null, "Livro excluído com sucesso!");
        } catch (SQLException e) {
            JOptionPane.showMessageDialog(null, "Erro: " + e.getMessage());
        }
    }

    public void realizarEmprestimo(int idUsuario, int idLivro) {
        String sql = "{CALL sp_transacao_emprestimo(?, ?)}";
        try (CallableStatement cs = conexao.prepareCall(sql)) {
            cs.setInt(1, idUsuario);
            cs.setInt(2, idLivro);
            cs.execute();
            JOptionPane.showMessageDialog(null, "Empréstimo realizado com sucesso!");
        } catch (SQLException e) {
            JOptionPane.showMessageDialog(null, "Erro: " + e.getMessage());
        }
    }

    public void realizarDevolucao(int idEmprestimo) {
        String sql = "UPDATE emprestimos SET data_devolucao = CURRENT_DATE WHERE id_emprestimo = ?";
        try (PreparedStatement ps = conexao.prepareStatement(sql)) {
            ps.setInt(1, idEmprestimo);
            ps.executeUpdate();
            JOptionPane.showMessageDialog(null, "Devolução processada.");
        } catch (SQLException e) {
            JOptionPane.showMessageDialog(null, "Erro: " + e.getMessage());
        }
    }

    public void consultarAcervoPublico() {
        String sql = "SELECT * FROM vw_acervo_publico";
        try (Statement st = conexao.createStatement(); ResultSet rs = st.executeQuery(sql)) {
            StringBuilder sb = new StringBuilder("Acervo Disponível:\n");
            while (rs.next()) {
                sb.append(rs.getString("titulo")).append(" - ").append(rs.getString("autor")).append("\n");
            }
            JOptionPane.showMessageDialog(null, sb.toString());
        } catch (SQLException e) {
            JOptionPane.showMessageDialog(null, "Erro: " + e.getMessage());
        }
    }

    public void listarMeusEmprestimos(int idUsuario) {
        String sql = "SELECT l.titulo, e.data_saida, e.data_prevista FROM emprestimos e JOIN livros l ON e.id_livro_fk = l.id_livro WHERE e.id_usuario_fk = ?";
        try (PreparedStatement ps = conexao.prepareStatement(sql)) {
            ps.setInt(1, idUsuario);
            ResultSet rs = ps.executeQuery();
            StringBuilder sb = new StringBuilder("Seus Empréstimos:\n");
            while (rs.next()) {
                sb.append(rs.getString("titulo")).append(" (Prev: ").append(rs.getDate("data_prevista")).append(")\n");
            }
            JOptionPane.showMessageDialog(null, sb.toString());
        } catch (SQLException e) {
            JOptionPane.showMessageDialog(null, "Erro: " + e.getMessage());
        }
    }

    public void exibirDashboardFinanceiro() {
        String sql = "SELECT * FROM vw_dashboard_financeiro";
        try (Statement st = conexao.createStatement(); ResultSet rs = st.executeQuery(sql)) {
            if (rs.next()) {
                JOptionPane.showMessageDialog(null, "Total Arrecadado: R$ " + rs.getDouble("total_arrecadado"));
            }
        } catch (SQLException e) {
            JOptionPane.showMessageDialog(null, "Erro: " + e.getMessage());
        }
    }

    public void gerarBackup(String caminhoDestino) {
        String mysqldumpPath = "C:\\Program Files\\MySQL\\MySQL Server 8.0\\bin\\mysqldump.exe";
        String[] comando = {mysqldumpPath, "-uroot", "-proot", "--databases", "facisas_archive", "-r", caminhoDestino};
        try {
            Process process = Runtime.getRuntime().exec(comando);
            if (process.waitFor() == 0) {
                JOptionPane.showMessageDialog(null, "Backup gerado com sucesso.");
            } else {
                JOptionPane.showMessageDialog(null, "Falha ao gerar backup.");
            }
        } catch (Exception e) {
            JOptionPane.showMessageDialog(null, "Erro: " + e.getMessage());
        }
    }
}