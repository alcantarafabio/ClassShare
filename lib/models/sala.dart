class Sala {
  final int? id;
  final String nome;

  Sala({this.id, required this.nome});

  factory Sala.fromMap(Map<String, dynamic> map) =>
      Sala(id: map['id'], nome: map['nome']);

  Map<String, dynamic> toMap() => {'nome': nome};
}
