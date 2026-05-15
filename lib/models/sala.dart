class Sala {
  final int? id;
  final String nome;
  final int semestreId;

  Sala({this.id, required this.nome, required this.semestreId});

  factory Sala.fromMap(Map<String, dynamic> map) => Sala(
    id: map['id'],
    nome: map['nome'],
    semestreId: map['semestre_id'] as int,
  );

  Map<String, dynamic> toMap() => {'nome': nome, 'semestre_id': semestreId};
}
