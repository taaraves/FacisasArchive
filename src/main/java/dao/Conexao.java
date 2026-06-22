package dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class Conexao {
    private static final String URL = "jdbc:mysql://localhost:3306/facisas_archive?useSSL=false&serverTimezone=America/Sao_Paulo&allowPublicKeyRetrieval=true";

    public static Connection conectar(String usuario, String senha) throws SQLException {
        try {

            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            System.out.println("Erro: O Maven não baixou o Driver JDBC!");
        }
        return DriverManager.getConnection(URL, usuario, senha);
    }
}