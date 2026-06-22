package model;

public class Funcionario extends Usuario {

    public Funcionario(String tipoFuncionario) {

        super.setTipo(tipoFuncionario);
    }

    @Override
    public int getDiasPrazoEmprestimo() {
        return 14;
    }
}