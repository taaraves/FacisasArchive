package model;

public class Livro {
    private int idLivro;
    private String titulo;
    private String autor;
    private String isbn;
    private double precoCusto;
    private int quantidadeEstoque;
    private String status;

    public Livro() {}


    public void setPrecoCusto(double precoCusto) {
        if (precoCusto < 0) {
            throw new IllegalArgumentException("O preço de custo não pode ser negativo.");
        }
        this.precoCusto = precoCusto;
    }


    public int getIdLivro() { return idLivro; }
    public void setIdLivro(int idLivro) { this.idLivro = idLivro; }

    public String getTitulo() { return titulo; }
    public void setTitulo(String titulo) { this.titulo = titulo; }

    public String getAutor() { return autor; }
    public void setAutor(String autor) { this.autor = autor; }

    public String getIsbn() { return isbn; }
    public void setIsbn(String isbn) { this.isbn = isbn; }

    public double getPrecoCusto() { return precoCusto; }

    public int getQuantidadeEstoque() { return quantidadeEstoque; }
    public void setQuantidadeEstoque(int quantidadeEstoque) { this.quantidadeEstoque = quantidadeEstoque; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
}