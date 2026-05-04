class Usuaria {
  final String id;
  final String nome;
  final int? idade;
  final String email;
  final String? faseDaVida;

  const Usuaria({
    required this.id,
    required this.nome,
    this.idade,
    required this.email,
    this.faseDaVida,
  });
}
