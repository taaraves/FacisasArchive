package view;

import dao.LivroDAO;
import model.Livro;
import javax.swing.*;
import java.awt.*;
import java.sql.Connection;

public class MenuPrincipal extends JFrame {
    private LivroDAO dao;

    public MenuPrincipal(Connection conexao, int perfil) {
        this.dao = new LivroDAO(conexao);
        setTitle("LibriTech - Gestão");
        setSize(350, 400);
        setLayout(new GridLayout(0, 1));

        JButton btnCadastrar = new JButton("Cadastrar Livro");
        JButton btnEmprestar = new JButton("Empréstimo");
        JButton btnDevolver = new JButton("Devolução");
        JButton btnExcluir = new JButton("Excluir Livro");
        JButton btnFinanceiro = new JButton("Financeiro");
        JButton btnBackup = new JButton("Backup");
        JButton btnAcervo = new JButton("Acervo Público");
        JButton btnMeusEmprestimos = new JButton("Meus Empréstimos");

        if (perfil == 0) {
            add(btnCadastrar); add(btnEmprestar); add(btnDevolver); add(btnExcluir); add(btnFinanceiro); add(btnBackup);
        } else if (perfil == 1) {
            add(btnCadastrar); add(btnEmprestar); add(btnDevolver);
        } else if (perfil == 2) {
            add(btnEmprestar);
        } else if (perfil == 3) {
            add(btnAcervo); add(btnMeusEmprestimos);
        }

        btnCadastrar.addActionListener(e -> {
            Livro l = new Livro();
            l.setTitulo(JOptionPane.showInputDialog("Título:"));
            l.setAutor(JOptionPane.showInputDialog("Autor:"));
            l.setIsbn(JOptionPane.showInputDialog("ISBN:"));
            l.setPrecoCusto(Double.parseDouble(JOptionPane.showInputDialog("Preço:")));
            l.setQuantidadeEstoque(Integer.parseInt(JOptionPane.showInputDialog("Qtd:")));
            l.setStatus("DISPONIVEL");
            dao.cadastrarLivro(l);
        });
        btnEmprestar.addActionListener(e -> dao.realizarEmprestimo(Integer.parseInt(JOptionPane.showInputDialog("ID Usuário:")), Integer.parseInt(JOptionPane.showInputDialog("ID Livro:"))));
        btnDevolver.addActionListener(e -> dao.realizarDevolucao(Integer.parseInt(JOptionPane.showInputDialog("ID Empréstimo:"))));
        btnExcluir.addActionListener(e -> dao.excluirLivro(Integer.parseInt(JOptionPane.showInputDialog("ID Livro:"))));
        btnFinanceiro.addActionListener(e -> dao.exibirDashboardFinanceiro());
        btnBackup.addActionListener(e -> dao.gerarBackup("C:\\Backup\\facisa.sql"));
        btnAcervo.addActionListener(e -> dao.consultarAcervoPublico());
        btnMeusEmprestimos.addActionListener(e -> dao.listarMeusEmprestimos(Integer.parseInt(JOptionPane.showInputDialog("ID Aluno:"))));

        setDefaultCloseOperation(DISPOSE_ON_CLOSE);
        setLocationRelativeTo(null);
        setVisible(true);
    }
}