class Semestre {
  final int? id;
  final String nome;
  final int cursoId;

  Semestre({this.id, required this.nome, required this.cursoId});

  factory Semestre.fromMap(Map<String, dynamic> map) => Semestre(
    id: map['id'],
    nome: map['nome'],
    cursoId: map['curso_id'] as int,
  );
}
