import 'package:flutter/material.dart';
import '../models/sala.dart';
import '../theme/app_theme.dart';

class CardSala extends StatelessWidget {
  final Sala sala;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const CardSala({
    super.key,
    required this.sala,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: const CircleAvatar(
          backgroundColor: AppTheme.primary,
          child: Icon(Icons.class_outlined, color: Colors.white),
        ),
        title: Text(
          sala.nome,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: const Text('Toque para ver as fotos'),
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
          tooltip: 'Excluir sala',
          onPressed: onDelete,
        ),
        onTap: onTap,
      ),
    );
  }
}
