class Semestre {
  final int? id;
  final String nome;

  Semestre({this.id, required this.nome});

  factory Semestre.fromMap(Map<String, dynamic> map) =>
      Semestre(id: map['id'], nome: map['nome']);
}
