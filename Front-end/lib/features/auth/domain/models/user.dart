class User {
  final String id;
  final String nome;
  final String email;
  final String cargo;

  User({
    required this.id,
    required this.nome,
    required this.email,
    required this.cargo,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      nome: json['nome'],
      email: json['email'],
      cargo: json['cargo'],
    );
  }
}
