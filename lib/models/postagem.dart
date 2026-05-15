class Postagem {
  final int? id;
  final String titulo;
  final String descricao;
  final String caminhoImagem;
  final int salaId;
  final String data;

  Postagem({
    this.id,
    required this.titulo,
    required this.descricao,
    required this.caminhoImagem,
    required this.salaId,
    required this.data,
  });

  factory Postagem.fromMap(Map<String, dynamic> map) => Postagem(
    id: map['id'],
    titulo: map['titulo'],
    descricao: map['descricao'] ?? '',
    caminhoImagem: map['caminho_imagem'],
    salaId: map['sala_id'],
    data: map['data'],
  );
}
