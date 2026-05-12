class UsuariaModel {
  final String id;
  final String nome;
  final int? idade;
  final String email;
  final String? faseDaVida;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  UsuariaModel({
    required this.id,
    required this.nome,
    this.idade,
    required this.email,
    this.faseDaVida,
    this.createdAt,
    this.updatedAt,
  });

  factory UsuariaModel.fromJson(Map<String, dynamic> json) {
    return UsuariaModel(
      id: json['id'] as String,
      nome: json['nome'] as String? ?? '',
      idade: json['idade'] as int?,
      email: json['email'] as String? ?? '',
      faseDaVida: json['fase_da_vida'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'])
          : null,
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
    String? nome,
    int? idade,
    String? faseDaVida,
  }) {
    return UsuariaModel(
      id: id,
      nome: nome ?? this.nome,
      idade: idade ?? this.idade,
      email: email,
      faseDaVida: faseDaVida ?? this.faseDaVida,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
