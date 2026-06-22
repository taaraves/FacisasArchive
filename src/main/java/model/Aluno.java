package model;



public class Aluno extends Usuario {

    public Aluno() {
        super.setTipo("ALUNO");
    }

    @Override
    public int getDiasPrazoEmprestimo() {
        return 7;
    }
}