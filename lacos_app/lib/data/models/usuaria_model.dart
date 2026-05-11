class UsuariaModel {
  final String id;
  final String nome;
  final int? idade;
  final String email;
  final String? faseDaVida;

  UsuariaModel({
    required this.id,
    required this.nome,
    this.idade,
    required this.email,
    this.faseDaVida,
  });

  factory UsuariaModel.fromJson(Map<String, dynamic> json) {
    return UsuariaModel(
      id: json['id'] as String,
      nome: json['nome'] as String,
      idade: json['idade'] as int?,
      email: json['email'] as String,
      faseDaVida: json['fase_da_vida'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'idade': idade,
      'email': email,
      'fase_da_vida': faseDaVida,
    };
  }

  UsuariaModel copyWith({
    String? id,
    String? nome,
    int? idade,
    String? email,
    String? faseDaVida,
  }) {
    return UsuariaModel(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      idade: idade ?? this.idade,
      email: email ?? this.email,
      faseDaVida: faseDaVida ?? this.faseDaVida,
    );
  }
}
