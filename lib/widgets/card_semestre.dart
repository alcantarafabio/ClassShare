import 'package:flutter/material.dart';
import '../models/semestre.dart';
import '../theme/app_theme.dart';

class CardSemestre extends StatelessWidget {
  final Semestre semestre;
  final VoidCallback onTap;

  const CardSemestre({
    super.key,
    required this.semestre,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        leading: const CircleAvatar(
          backgroundColor: AppTheme.primary,
          child: Icon(Icons.calendar_today, color: Colors.white, size: 20),
        ),
        title: Text(
          semestre.nome,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),
        subtitle: const Text('Toque para ver as disciplinas'),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}
