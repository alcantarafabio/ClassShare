class Curso {
  final int? id;
  final String nome;

  Curso({this.id, required this.nome});

  factory Curso.fromMap(Map<String, dynamic> map) =>
      Curso(id: map['id'], nome: map['nome']);

  Map<String, dynamic> toMap() => {'nome': nome};
}
