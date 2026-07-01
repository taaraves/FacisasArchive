import dao.Conexao;
import view.MenuPrincipal;
import javax.swing.*;
import java.sql.Connection;

public class App {
    public static void main(String[] args) {
        String[] perfis = {"Gerente", "Bibliotecário", "Estagiário", "Aluno", "Sair"};
        int escolhaPerfil = JOptionPane.showOptionDialog(null, "Perfil:", "LibriTech", JOptionPane.DEFAULT_OPTION, JOptionPane.QUESTION_MESSAGE, null, perfis, perfis[0]);
        if (escolhaPerfil == 4 || escolhaPerfil == JOptionPane.CLOSED_OPTION) System.exit(0);
        String usuarioBanco = JOptionPane.showInputDialog("Usuário:");
        String senhaBanco = JOptionPane.showInputDialog("Senha:");
        try {
            Connection conexao = Conexao.conectar(usuarioBanco, senhaBanco);
            SwingUtilities.invokeLater(() -> new MenuPrincipal(conexao, escolhaPerfil));
        } catch (Exception e) {
            JOptionPane.showMessageDialog(null, "Erro: " + e.getMessage());
        }
    }
}